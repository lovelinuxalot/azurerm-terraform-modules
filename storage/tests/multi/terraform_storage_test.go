package test

import (
	"context"
	"fmt"
	"github.com/Azure/azure-sdk-for-go/profiles/latest/storage/mgmt/storage"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"strings"
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

		accountName := terraform.OutputList(t, terraformOptions, "storage_account_name")
		resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")
		shares := terraform.OutputList(t, terraformOptions, "share_name")
		//frontendPort := terraform.Output(t, terraformOptions, "app_gw_frontend_ports")

		accountNameOne := removeCharacters(accountName[0], "[]")
		shareName := removeCharacters(shares[0], "[]")
		fmt.Println(shareName)

		accountList := ListStorageAccounts(t, resourceGroupName, subscriptionID)
		expectedAccountCount := 2
		assert.Equal(t, expectedAccountCount, len(accountList))
		assert.Contains(t, accountList, accountNameOne, "Does not exists")

		sharesList := ListFileShares(t, resourceGroupName, "", accountName[0])
		expectedSharesCount := 1
		assert.Equal(t, expectedSharesCount, len(sharesList))
		assert.Contains(t, sharesList, shareName, "Does not exist")
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
func ListFileShares(t *testing.T, resourceGroupName string, subscriptionID string, accountName string) []string {
	shares, err := ListFileSharesE(resourceGroupName, subscriptionID, accountName)
	require.NoError(t, err)
	return shares
}

func ListFileSharesE(resourceGroupName string, subscriptionID string, accountName string) ([]string, error) {
	var sharesList []string
	ctx, cancel := context.WithTimeout(context.Background(), 6000*time.Second)
	defer cancel()

	sharesClient, err := GetFileSharesClient(subscriptionID)
	if err != nil {
		return nil, err
	}
	shares, err := sharesClient.List(ctx, resourceGroupName, accountName, "", "", "")
	if err != nil {
		return nil, err
	}

	for _, v := range shares.Values() {
		sharesList = append(sharesList, *v.Name)
	}
	return sharesList, nil
}

func GetFileSharesClient(subscriptionID string) (*storage.FileSharesClient, error) {
	newSubscriptionID, err := azure.GetTargetAzureSubscription(subscriptionID)
	if err != nil {
		return nil, err
	}

	sharesClient := storage.NewFileSharesClient(newSubscriptionID)
	authorizer, err := azure.NewAuthorizer()
	if err != nil {
		return nil, err
	}
	sharesClient.Authorizer = *authorizer
	return &sharesClient, nil
}

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

func removeCharacters(input string, characters string) string {
	filter := func(r rune) rune {
		if strings.IndexRune(characters, r) < 0 {
			return r
		}
		return -1
	}

	return strings.Map(filter, input)

}
