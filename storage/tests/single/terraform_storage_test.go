package test

import (
	"context"
	"github.com/Azure/azure-sdk-for-go/profiles/latest/storage/mgmt/storage"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"testing"
	"time"
)

func TestTerraformNatGateway(t *testing.T) {
	t.Parallel()

	fixtureFolder := "./fixtures"

	// Deploy the example
	test_structure.RunTestStage(t, "setup", func() {
		terraformOptions := configureTerraformOptions(fixtureFolder)

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

		accountName := terraform.Output(t, terraformOptions, "storage_account_name")
		resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")
		//frontendPort := terraform.Output(t, terraformOptions, "app_gw_frontend_ports")

		//appGwsName  := removeCharacters(appGws[0], "[]")

		accountList := ListStorageAccounts(t, resourceGroupName, subscriptionID)
		expectedAccountCount := 1
		assert.Equal(t, expectedAccountCount, len(accountList))
		assert.Contains(t, accountList, accountName, "Does not exists")

	})

	// At the end of the test, clean up any resources that were created
	test_structure.RunTestStage(t, "teardown", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, fixtureFolder)
		terraform.Destroy(t, terraformOptions)
	})

}

// Returns configurations for Terraform to run
//TODO test without "t"
func configureTerraformOptions(fixtureFolder string) *terraform.Options {

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: fixtureFolder,

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{},
	}

	return terraformOptions
}

//
func ListStorageAccounts(t *testing.T, resourceGroupName string, subscriptionID string) []string {
	accounts, err := ListStorageAccountsE(resourceGroupName, subscriptionID)
	require.NoError(t, err)
	return accounts
}

func ListStorageAccountsE(resourceGroupName string, subscriptionID string) ([]string, error) {
	var accountsList []string
	ctx, cancel := context.WithTimeout(context.Background(), 6000*time.Second)
	defer cancel()

	accountsClient, err := GetStorageAccountClient(subscriptionID)
	if err != nil {
		return nil, err
	}
	accounts, err := accountsClient.ListByResourceGroup(ctx, resourceGroupName)
	if err != nil {
		return nil, err
	}

	for _, v := range *accounts.Value {
		accountsList = append(accountsList, *v.Name)
	}
	return accountsList, nil
}

func GetStorageAccountClient(subscriptionID string) (*storage.AccountsClient, error) {
	newSubscriptionID, err := azure.GetTargetAzureSubscription(subscriptionID)
	if err != nil {
		return nil, err
	}

	accountsClient := storage.NewAccountsClient(newSubscriptionID)
	authorizer, err := azure.NewAuthorizer()
	if err != nil {
		return nil, err
	}
	accountsClient.Authorizer = *authorizer
	return &accountsClient, nil
}
