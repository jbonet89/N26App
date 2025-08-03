@isTest
private class ContactRestServiceTest {

    @TestSetup
    static void makeData(){

        // Create a test contact
        ContactTestDataFactory.createTestContact('12345678-1234-5678', 'John', 'Doe', 'john.doe@example.com', '123-456-7890', 'DE', 'Black', true);
       
    }

    @IsTest
    static void testGetContactByUUID() {

        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/ContactService/v1/12345678-1234-5678';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        // Call the REST service
        ContactRestService.ContactResponse response = ContactRestService.getContactByUUID();

        // Assert the response
        Assert.areEqual(true, response.success);
        Assert.areEqual(200, response.statusCode);
        Assert.areEqual('Contact retrieved successfully', response.message);
        Assert.isNotNull(response.contactInfo);
        Assert.areEqual('John', response.contactInfo.firstName);
        Assert.areEqual('Doe', response.contactInfo.lastName);
        Assert.areEqual('john.doe@example.com', response.contactInfo.email);
        Assert.areEqual('123-456-7890', response.contactInfo.phone);
        Assert.areEqual('DE', response.contactInfo.homeCountry);
        Assert.areEqual('Black', response.contactInfo.productPlan);
        Assert.isNotNull(response.contactInfo.pricingInfo.atmFee);
        Assert.isNotNull(response.contactInfo.pricingInfo.cardReplacementCost);
        Assert.isNotNull(response.contactInfo.pricingInfo.monthlyFee);
        Assert.isNotNull(response.contactInfo.pricingInfo.validFrom);
        Assert.isNotNull(response.contactInfo.pricingInfo.validTo);
    }

    @IsTest
    static void testNotFoundGetContactByUUID() {

        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/ContactService/v1/12345678';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        // Call the REST service
        ContactRestService.ContactResponse response = ContactRestService.getContactByUUID();

        // Assert the response
        Assert.areEqual(false, response.success);
        Assert.areEqual(404, response.statusCode);
        Assert.areEqual('No contact found with the provided UUID', response.message);
        Assert.isNull(response.contactInfo);
    }

    @IsTest
    static void testNotUUIDGetContactByUUID() {

        // Set up the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/ContactService/v1/';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        // Call the REST service
        ContactRestService.ContactResponse response = ContactRestService.getContactByUUID();

        // Assert the response
        Assert.areEqual(false, response.success);
        Assert.areEqual(400, response.statusCode);
        Assert.areEqual('UUID parameter is required', response.message);
        Assert.isNull(response.contactInfo);
    }

}