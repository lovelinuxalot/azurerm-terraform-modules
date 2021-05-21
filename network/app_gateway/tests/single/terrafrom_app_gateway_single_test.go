package test

import (
	"context"
	"fmt"

	"github.com/Azure/azure-sdk-for-go/services/network/mgmt/2020-07-01/network"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	//"strings"
	"testing"
	"time"
)

func TestTerraformNatGateway(t *testing.T) {
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

		appGwsName:= terraform.Output(t, terraformOptions, "app_gw_name")
		resourceGroupName := terraform.Output(t, terraformOptions, "app_gw_rg")
		frontendPort := terraform.Output(t, terraformOptions, "app_gw_frontend_ports")

		//appGwsName  := removeCharacters(appGws[0], "[]")

		appGwsList := ListAppGws(t, resourceGroupName, subscriptionID)
		expectedSsCount := 1
		assert.Equal(t, expectedSsCount, len(appGwsList))
		assert.Contains(t, appGwsList, appGwsName, "Does not exists")

		appGwInfo, err := GetAppGwInfo(subscriptionID, resourceGroupName, appGwsName)
		if err != nil{
			fmt.Println("No info received")
		}

		for _, v := range *appGwInfo.FrontendPorts {
			assert.Equal(t, *v.Name, frontendPort, "port name does not match")
		}
		assert.False(t, *appGwInfo.EnableHTTP2, "Wrong Enabled http2 Value found")
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



func ListAppGws(t *testing.T, resourceGroupName string, subscriptionID string) []string {
	appgws, err := ListAppGwsE(resourceGroupName, subscriptionID)
	require.NoError(t, err)
	return appgws
}

func ListAppGwsE(resourceGroupName string, subscriptionID string) ([]string, error) {
	var appGwsList []string
	ctx, cancel := context.WithTimeout(context.Background(), 6000*time.Second)
	defer cancel()

	appGwsClient, err := GetAppGwsClient(subscriptionID)
	if err != nil {
		return nil, err
	}
	appGws, err := appGwsClient.List(ctx, resourceGroupName)
	if err != nil {
		return nil, err
	}

	for _, v := range appGws.Values() {
		appGwsList = append(appGwsList, *v.Name)
	}
	return appGwsList, nil
}

func GetAppGwsClient(subscriptionID string) (*network.ApplicationGatewaysClient, error) {
	newSubscriptionID, err := azure.GetTargetAzureSubscription(subscriptionID)
	if err != nil {
		return nil, err
	}

	appGwsClient := network.NewApplicationGatewaysClient(newSubscriptionID)
	authorizer, err := azure.NewAuthorizer()
	if err != nil {
		return nil, err
	}
	appGwsClient.Authorizer = *authorizer
	return &appGwsClient, nil
}

func GetAppGwInfo(subscriptionID string, resourceGroupName string, appGwName string) (*network.ApplicationGateway, error) {
	appGwClient, err := GetAppGwsClient(subscriptionID)
	if err != nil{
		return nil, err
	}
	appGwInfo, err:= appGwClient.Get(context.Background(), resourceGroupName, appGwName)
	if err != nil {
		return nil, err
	}
	return &appGwInfo, nil
}
