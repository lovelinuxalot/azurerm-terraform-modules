package multi_vnet

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/test-structure"
// 	"github.com/gruntwork-io/terratest/modules/azure"
// 	"github.com/stretchr/testify/assert"
)

func TestTerraformSubnet(t *testing.T) {
    t.Parallel()

    fixtureFolder := "./fixtures"

    //Deploy the test example
    test_structure.RunTestStage(t, "setup", func() {
		terraformOptions := configureTerraformOptions(t, fixtureFolder)

		// Save the options so later test stages can use them
		test_structure.SaveTerraformOptions(t, fixtureFolder, terraformOptions)

		// This will init and apply the resources and fail the test if there are any errors
		terraform.InitAndApply(t, terraformOptions)
	})

	// Check whether the length of output meets the requirement
// 	test_structure.RunTestStage(t, "validate", func() {
// 		terraformOptions := test_structure.LoadTerraformOptions(t, fixtureFolder)
//
// //         resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")
// 		nsgName := terraform.Output(t, terraformOptions, "test_network_security_group_name")
// 		ruleName := terraform.Output(t, terraformOptions, "test_network_rule")
// 		if len(nsgName) <= 0 {
// 			t.Fatal("Wrong output for test_network_security_group_name")
// 		}
// 		if len(ruleName) <= 0 {
// 			t.Fatal("Wrong output for test_network_rule")
// 		}

// Cant test this with the current test, as i am passing values as list and terratest do not support port ranges

//         // A default NSG has 6 rules, and we have two custom rules for a total of 8
// 		rules, err := azure.GetAllNSGRulesE(resourceGroupName, nsgName, "")
// 		assert.NoError(t, err)
//         assert.Equal(t, 8, len(rules.SummarizedRules))
//
//         sshRule := rules.FindRuleByName("AllowSSHFromNET")
//
//         // That rule should allow port 22 inbound
//         assert.True(t, sshRule.AllowsDestinationPort(t, "22"))
//
//         // But should not allow 80 inbound
//         assert.False(t, sshRule.AllowsDestinationPort(t, "80"))
//
//         // We should have a rule for blocking HTTP
//         httpRule := rules.FindRuleByName("webrule")
//
//         // This rule should BLOCK port 80 inbound
//         assert.False(t, httpRule.AllowsDestinationPort(t, "80"))

// 	})

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
