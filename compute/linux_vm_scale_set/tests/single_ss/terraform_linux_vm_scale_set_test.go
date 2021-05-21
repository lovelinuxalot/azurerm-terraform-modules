package single_ss

import (
	"context"
	"fmt"
	"github.com/Azure/azure-sdk-for-go/services/compute/mgmt/2020-06-30/compute"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"strings"
	"testing"
	"time"
)

func TestTerraformLinuxVM(t *testing.T) {
	t.Parallel()

	fixtureFolder := "./fixtures"

	// Deploy the example
	test_structure.RunTestStage(t, "setup", func() {
		terraformOptions := configureTerraformOptions(t, fixtureFolder)

		// Save the options so later test stages can use them
		test_structure.SaveTerraformOptions(t, fixtureFolder, terraformOptions)

		// This will init and apply the resources and fail the test if there are any errors
		terraform.InitAndApply(t, terraformOptions)
	})

	// Check whether the length of output meets the requirement
	test_structure.RunTestStage(t, "validate", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, fixtureFolder)
	//
	//	// Get outputs from Terraform outputs
		subscriptionID := ""

		ssValue:= terraform.OutputList(t, terraformOptions, "virtual_machine_linux_scale_set_name")
		resourceGroupName := terraform.Output(t, terraformOptions, "scaleset_resource_group")

		scalesetName  := removeCharacters(ssValue[0], "[]")

		scaleSet := ListScaleSet(t, resourceGroupName, subscriptionID)
		expectedSsCount := 1
		assert.Equal(t, expectedSsCount, len(scaleSet))
		assert.Contains(t, scaleSet, scalesetName, "Does not exists")

		ssInfo, err := GetVMSSInfo(subscriptionID, resourceGroupName, scalesetName)
		if err != nil{
			fmt.Println("No info received")
		}
		assert.False(t, *ssInfo.Overprovision, "Wrong overprovision Value found")
		assert.False(t, *ssInfo.SinglePlacementGroup, "Wrong Single placement group value found")
	})

	// At the end of the test, clean up any resources that were created
	test_structure.RunTestStage(t, "teardown", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, fixtureFolder)
		terraform.Destroy(t, terraformOptions)
	})

}

// Returns configurations for Terraform to run
func configureTerraformOptions(t *testing.T, fixtureFolder string) *terraform.Options {

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: fixtureFolder,

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{},
	}

	return terraformOptions
}

func ListScaleSet(t *testing.T, resourceGroupName string, subscriptionID string) []string {
	ngws, err := ListScaleSetE(resourceGroupName, subscriptionID)
	require.NoError(t, err)
	return ngws
}

func ListScaleSetE(resourceGroupName string, subscriptionID string) ([]string, error) {
	var ss []string
	ctx, cancel := context.WithTimeout(context.Background(), 6000*time.Second)
	defer cancel()

	ssClient, err := GetVMSSClient(subscriptionID)
	if err != nil {
		return nil, err
	}
	vmss, err := ssClient.List(ctx, resourceGroupName)
	if err != nil {
		return nil, err
	}

	for _, v := range vmss.Values() {
		ss = append(ss, *v.Name)
	}
	return ss, nil
}

func GetVMSSClient(subscriptionID string) (*compute.VirtualMachineScaleSetsClient, error) {
	newSubscriptionID, err := azure.GetTargetAzureSubscription(subscriptionID)
	if err != nil {
		return nil, err
	}

	vmssClient := compute.NewVirtualMachineScaleSetsClient(newSubscriptionID)
	authorizer, err := azure.NewAuthorizer()
	if err != nil {
		return nil, err
	}
	vmssClient.Authorizer = *authorizer
	return &vmssClient, nil
}

func GetVMSSInfo(subscriptionID string, resourceGroupName string, statefulSetName string) (*compute.VirtualMachineScaleSet, error) {
	ssClient, err := GetVMSSClient(subscriptionID)
	if err != nil{
		return nil, err
	}
	ssInfo, err:= ssClient.Get(context.Background(), resourceGroupName, statefulSetName)
	if err != nil {
		return nil, err
	}
	return &ssInfo, nil
}
func removeCharacters(input string, characters string) string {
	filter := func(r rune) rune {
		if strings.IndexRune(characters, r) < 0 {
			return r
		}
		return -1
	}

	return strings.Map(filter, input)

}