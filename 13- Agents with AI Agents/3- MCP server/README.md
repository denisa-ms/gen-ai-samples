# Develop a multi-agent solution

In this exercise, you'll create a project that orchestrates multiple AI agents using Azure AI Foundry Agent Service. You'll design an AI solution that assists with ticket triage. The connected agents will assess the ticket's priority, suggest a team assignment, and determine the level of effort required to complete the ticket. Let's get started!

> **Tip**: The code used in this exercise is based on the for Azure AI Foundry SDK for Python. You can develop similar solutions using the SDKs for Microsoft .NET, JavaScript, and Java. Refer to [Azure AI Foundry SDK client libraries](https://learn.microsoft.com/azure/ai-foundry/how-to/develop/sdk-overview) for details.


> **Note**: Some of the technologies used in this exercise are in preview or in active development. You may experience some unexpected behavior, warnings, or errors.

## Deploy a model in an Azure AI Foundry project

Let's start by deploying a model in an Azure AI Foundry project.

1. In a web browser, open the [Azure AI Foundry portal](https://ai.azure.com) at `https://ai.azure.com` and sign in using your Azure credentials. Close any tips or quick start panes that are opened the first time you sign in, and if necessary use the **Azure AI Foundry** logo at the top left to navigate to the home page, which looks similar to the following image (close the **Help** pane if it's open):

    ![Screenshot of Azure AI Foundry portal.](../media/ai-foundry-home.png)

1. In the home page, in the **Explore models and capabilities** section, search for the `gpt-4o` model; which we'll use in our project.
1. In the search results, select the **gpt-4o** model to see its details, and then at the top of the page for the model, select **Use this model**.
1. When prompted to create a project, enter a valid name for your project and expand **Advanced options**.
1. Confirm the following settings for your project:
    - **Azure AI Foundry resource**: *A valid name for your Azure AI Foundry resource*
    - **Subscription**: *Your Azure subscription*
    - **Resource group**: *Create or select a resource group*
    - **Region**: *Select any **AI Services supported location***\*

    > \* Some Azure AI resources are constrained by regional model quotas. In the event of a quota limit being exceeded later in the exercise, there's a possibility you may need to create another resource in a different region.

1. Select **Create** and wait for your project, including the gpt-4 model deployment you selected, to be created.
1. When your project is created, the chat playground will be opened automatically.

    > **Note**: The default TPM setting for this model may be too low for this exercise. A lower TPM helps avoid over-using the quota available in the subscription you are using. 

1. In the navigation pane on the left, select **Models and endpoints** and select your **gpt-4o** deployment.

1. Select **Edit** then increase the **Tokens per Minute Rate Limit**

   > **NOTE**: 40,000 TPM should be sufficient for the data used in this exercise. If your available quota is lower than this, you will be able to complete the exercise but you may need to wait and resubmit prompts if the rate limit is exceeded.

1. In the navigation pane on the left, select **Overview** to see the main page for your project; which looks like this:

    ![Screenshot of a Azure AI Foundry project overview page.](../media/ai-foundry-project.png)

1. Copy the **Azure AI Foundry project endpoint** value to a notepad, as you'll use it to connect to your project in a client application.

Make sure you fill the .env file with the values for environment variables as follows:   

AIFOUNDRY_AGENT_PROJECT_NAME="ai foundry project endpoint"   
AIFOUNDRY_AGENT_MODEL_DEPLOYMENT_NAME = "gpt4-o"  

12. Login to azure by running az login command from the terminal
    ```
    az login
    ```

    **<font color="red">You must sign into Azure - even though the cloud shell session is already authenticated.</font>**

    > **Note**: In most scenarios, just using *az login* will be sufficient. However, if you have subscriptions in multiple tenants, you may need to specify the tenant by using the *--tenant* parameter. See [Sign into Azure interactively using the Azure CLI](https://learn.microsoft.com/cli/azure/authenticate-azure-cli-interactively) for details.