package test

import (
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestTerraformNicDynamic(t *testing.T) {
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

		nicId := terraform.Output(t, terraformOptions, "nic_id")
		if len(nicId) <= 0 {
			t.Fatal("Wrong output")
		}
		nicPrivateIp := terraform.Output(t, terraformOptions, "nic_private_ip_address")
		if len(nicPrivateIp) <= 0 {
			t.Fatal("Wrong output")
		}


		// Get outputs from Terraform outputs
		subnetName := terraform.Output(t, terraformOptions, "subnet_name")
		resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")
		vnetName := terraform.Output(t, terraformOptions, "vnet_name")

		//Check Subnet exists
		subnetExists := azure.SubnetExists(t, subnetName, vnetName, resourceGroupName, "")
		assert.True(t, subnetExists, "Subnet does not exist")

		// Check IP exists in subnet
		ipInSubnet := azure.CheckSubnetContainsIP(t, nicPrivateIp, subnetName, vnetName, resourceGroupName, "")
		assert.True(t, ipInSubnet, "IP does not exist in subnet")

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