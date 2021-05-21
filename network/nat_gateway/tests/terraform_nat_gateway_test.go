package test

import (
	"context"
	"github.com/Azure/azure-sdk-for-go/services/network/mgmt/2020-07-01/network"
	autorestAzure "github.com/Azure/go-autorest/autorest/azure"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"os"
	"reflect"
	"testing"
)
const (
	// AzureEnvironmentEnvName is the name of the Azure environment to use. Set to one of the following:
	//
	// "AzureChinaCloud":        ChinaCloud
	// "AzureGermanCloud":       GermanCloud
	// "AzurePublicCloud":       PublicCloud
	// "AzureUSGovernmentCloud": USGovernmentCloud
	// "AzureStackCloud":		 Azure stack
	AzureEnvironmentEnvName = "AZURE_ENVIRONMENT"

	// ResourceManagerEndpointName is the name of the ResourceManagerEndpoint field in the Environment struct.
	ResourceManagerEndpointName = "ResourceManagerEndpoint"
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

		natIP := terraform.Output(t, terraformOptions, "nat_gw_public_ip")
		if len(natIP) <= 0 {
			t.Fatal("Wrong output")
		}

		// Can be enabled once the FQDN has been implemented on Nat Gateway module
		//natFqdn := terraform.Output(t, terraformOptions, "nat_gw_public_fqdn")
		//if len(natFqdn) <= 0 {
		//	t.Fatal("Wrong output")
		//}

		natIpPrefix := terraform.Output(t, terraformOptions, "nat_prefix")
		if len(natIpPrefix) <= 0 {
			t.Fatal("Wrong output")
		}
		natGwId := terraform.Output(t, terraformOptions, "nat_gw_id")
		if len(natGwId) <= 0 {
			t.Fatal("Wrong output")
		}
		natGwAssId := terraform.Output(t, terraformOptions, "nat_gw_public_association_id")
		if len(natGwAssId) <= 0 {
			t.Fatal("Wrong output")
		}
		natGwName := terraform.Output(t, terraformOptions, "nat_gw_name")
		if len(natGwName) <= 0 {
			t.Fatal("Wrong output")
		}

		// Get outputs from Terraform outputs
		resourceGroupName := terraform.Output(t, terraformOptions, "nat_gw_resource_group_name")

		//Check against all NAT Gateways in a ResourceGroup
		natGwList := ListNatGatewayForResourceGroup(t, resourceGroupName, "")
		expectedNatGwCount := 1
		assert.Equal(t, expectedNatGwCount, len(natGwList))
		assert.Contains(t, natGwList, natGwName)

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



// ListNatGatewayForResourceGroup gets a list of all NAT Gateway names in the specified Resource Group.
// This function would fail the test if there is an error.
func ListNatGatewayForResourceGroup(t *testing.T, resourceGroupName string, subscriptionID string) []string {
	ngws, err := ListNatGatewaysForResourceGroupE(resourceGroupName, subscriptionID)
	require.NoError(t, err)
	return ngws
}

// ListNatGatewaysForResourceGroupE gets a list of all NAT Gateway names in the specified Resource Group.
func ListNatGatewaysForResourceGroupE(resourceGroupName string, subscriptionID string) ([]string, error) {
	var natGwDetails [] string

	natGwClient, err := GetNatGatewayClientE(subscriptionID)
	if err != nil {
		return nil, err
	}

	ngws, err := natGwClient.List(context.Background(), resourceGroupName)
	if err != nil {
		return nil, err
	}

	for _,v := range ngws.Values() {
		natGwDetails = append(natGwDetails, *v.Name)
	}

	return natGwDetails, nil
}

// GetNatGatewayClientE is a helper function that will setup an Azure NAT Gateway client on your behalf.
func GetNatGatewayClientE(subscriptionID string) (*network.NatGatewaysClient, error)  {
	natGwClient, err :=  CreateNatGatewaysClient(subscriptionID)
	if err != nil {
		return nil, err
	}

	authorizer, err := azure.NewAuthorizer()
	if err != nil {
		return nil, err
	}

	natGwClient.Authorizer = *authorizer
	return &natGwClient, nil
}

// CreateNatGatewaysClient returns a nat gateways client instance configured with the correct BaseURI depending on
// the Azure environment that is currently setup (or "Public", if none is setup).
func CreateNatGatewaysClient(subscriptionID string) (network.NatGatewaysClient, error)  {
	subscriptionID, err := azure.GetTargetAzureSubscription(subscriptionID)
	if err != nil {
		return network.NatGatewaysClient{}, err
	}

	baseURI, err := getEnvironmentEndpointE(ResourceManagerEndpointName)
	if err != nil {
		return network.NatGatewaysClient{}, err
	}
	return network.NewNatGatewaysClientWithBaseURI(baseURI, subscriptionID), nil
}

// getDefaultEnvironmentName returns either a configured Azure environment name, or the public default
func getDefaultEnvironmentName() string {
	envName, exists := os.LookupEnv(AzureEnvironmentEnvName)

	if exists && len(envName) > 0 {
		return envName
	}

	return autorestAzure.PublicCloud.Name
}

// getEnvironmentEndpointE returns the endpoint identified by the endpoint name parameter.
func getEnvironmentEndpointE(endpointName string) (string, error) {
	envName := getDefaultEnvironmentName()
	env, err := autorestAzure.EnvironmentFromName(envName)
	if err != nil {
		return "", err
	}
	return getFieldValue(&env, endpointName), nil
}

// getFieldValue gets the field identified by the field parameter from the passed Environment struct
func getFieldValue(env *autorestAzure.Environment, field string) string {
	structValue := reflect.ValueOf(env)
	fieldVal := reflect.Indirect(structValue).FieldByName(field)
	return fieldVal.String()
}