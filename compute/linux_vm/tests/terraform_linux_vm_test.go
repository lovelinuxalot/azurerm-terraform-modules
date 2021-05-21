package tests

import (
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
	"testing"
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

		// Get outputs from Terraform outputs
		vmName := terraform.Output(t, terraformOptions, "vm_name")
		resourceGroupName := terraform.Output(t, terraformOptions, "vm_resource_group_name")
		nicName := terraform.Output(t, terraformOptions, "nic_name")

		//Check VM exists
		vmExists := azure.VirtualMachineExists(t, vmName, resourceGroupName, "")
		assert.True(t, vmExists, "Subnet does not exist")

		//Check NIC is in the list
		nicList := azure.GetVirtualMachineNics(t, vmName, resourceGroupName, "")
		expectedNatGwCount := 1
		assert.Equal(t, expectedNatGwCount, len(nicList))
		assert.Contains(t, nicList, nicName)

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