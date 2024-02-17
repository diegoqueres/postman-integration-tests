# postman-integration-tests

A bash script designed for running Postman integration tests in sequence. 

Before executing the script, ensure proper setup of required environment variables and creation of a configuration file.

This resource is available to developers aiming to test APIs using Postman, in addition to unit tests.

## Prerequisites

1. **Prepare your requests on Postman**

    Prepare the sequence of endpoints to be tested, so that with each request, postman must configures the necessary variables to run the next endpoint.

2. **Install Postman CLI**

    You must install Postman CLI on your computer. Follow the instructions in: <https://learning.postman.com/docs/postman-cli/postman-cli-installation/>

3. **Set Environment Variables**

    Set a prefix for your new environment variables. For instance, if your API refers to _customers_, the prefix could be _CUSTOMER_.
   
    The script needs the following environment variables to process tests:
    - `{{YOUR API ENV PREFIX}}_POSTMAN_APIKEY`: Postman API key for authentication.
    - `{{YOUR API ENV PREFIX}}_ENV_DEV_UUID`: UUID for the development environment.
    - `{{YOUR API ENV PREFIX}}_ENV_QA_UUID`: UUID for the QA environment.

    In our example, the environment variables would be:
    _CUSTOMER_POSTMAN_APIKEY, CUSTOMER_ENV_DEV_UUID and CUSTOMER_ENV_QA_UUID_.

    If you are using Linux, you can set these variables by adding the following lines to your shell profile file _(e.g., `~/.bashrc` or `~/.zshrc`)_:

    ```bash
    export CUSTOMER_POSTMAN_APIKEY="your_api_key_here"
    export CUSTOMER_ENV_DEV_UUID="your_dev_uuid_here"
    export CUSTOMER_ENV_QA_UUID="your_qa_uuid_here"
    ```

    Remember to reload your shell or open a new terminal window after making these changes.

4. **Create Configuration File**
    - Create a JSON configuration file at `$HOME/.postman/integration-tests/config.json`. You can follow the example file provided: `config.json.example`, consulting the Postman environment of your Api.

## Running Tests

1. After setting up the environment variables and creating the configuration file, run the following commands:

    ```bash  
    # if you run for the first time
    chmod +x run.sh
   
    ./run.sh
    ```

2. Follow the instructions provided by the script during the test execution. Ensure that the environment variables are correctly configured and the configuration file is in the right path.

3. The script will execute the integrated tests and provide feedback on the results.

Feel free to reach out if you encounter any issues or have questions about the test setup. 

**Happy testing!** :grinning:
