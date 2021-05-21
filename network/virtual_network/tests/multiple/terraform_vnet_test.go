package multiple

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/test-structure"
	"testing"
)

func TestTerraformNetwork(t *testing.T) {
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


       vnetRg := terraform.OutputMap(t, terraformOptions, "virtual_network_resource_group_name")
       if _, exists := vnetRg["vnet-d-gwc1-01"]; exists {
       	fmt.Printf("Resource group match %s for the vnet vnet-d-gwc1-01 \n", vnetRg["vnet-d-gwc1-01"] )
	   }

	})

	// At the end of the test, clean up any resources that were created
	test_structure.RunTestStage(t, "teardown", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, fixtureFolder)
		terraform.Destroy(t, terraformOptions)
	})

}

func configureTerraformOptions(t *testing.T, fixtureFolder string) *terraform.Options {

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: fixtureFolder,

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{},
	}

	return terraformOptions
}


//
//// ListVirtualNetworksForResourceGroup gets a list of all Virtual Network names in the specified Resource Group.
//// This function would fail the test if there is an error.
//func ListVirtualNetworksForResourceGroup(t *testing.T, resourceGroupName string, subscriptionID string) []string {
//	vnets, err := ListVirtualNetworksForResourceGroupE(resourceGroupName, subscriptionID)
//	require.NoError(t, err)
//	return vnets
//}
//
//// ListVirtualNetworksForResourceGroupE gets a list of all Virtual network names in the specified Resource Group.
//func ListVirtualNetworksForResourceGroupE(resourceGroupName string, subscriptionID string) ([]string, error) {
//	var vnetDetails [] string
//
//	vnetClient, err := azure.GetVirtualNetworksClientE(subscriptionID)
//	if err != nil {
//		return nil, err
//	}
//
//	vnets, err := vnetClient.List(context.Background(), resourceGroupName)
//	if err != nil {
//		return nil, err
//	}
//
//	for _,v := range vnets.Values() {
//		vnetDetails = append(vnetDetails, *v.Name)
//	}
//
//	return vnetDetails, nil
//}