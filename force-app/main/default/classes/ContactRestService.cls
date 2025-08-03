/**
    * @description REST API service to retrieve contact information by UUID
    * @author Jaume Bonet
    * @version 1.0
    * @date August 3, 2025
    */
    @RestResource(urlMapping='/ContactService/v1/*')
    global with sharing class ContactRestService {
    
    /**
        * GET method to retrieve contact information by UUID
        * @return Contact information in JSON format
        */
    @HttpGet
    global static ContactResponse getContactByUUID() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        try {
            // Extract UUID from the URL
            String uuid = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);
            
            if (String.isBlank(uuid)) {
                return new ContactResponse(false, 400, 'UUID parameter is required', null);
            }
            
            // Query for the contact with the provided UUID
            List<Contact> contacts = [
                SELECT Id, FirstName, LastName, Email, Phone, 
                        Home_Country__c, Product__c
                FROM Contact 
                WHERE UUID__c = :uuid
                LIMIT 1
            ];
            
            if (contacts.isEmpty()) {
                return new ContactResponse(false, 404, 'No contact found with the provided UUID', null);
            }
            
            Contact contact = contacts[0];
            
            //Fetch product pricing 
            ProductPricingByCountry__mdt pricingInfo = ProductPricingService.getProductPricing(contact.Product__c, contact.Home_Country__c);
            
            // Create and return the response
            ContactResponse response = new ContactResponse(true, 200, 'Contact retrieved successfully', new ContactInfo(contact, pricingInfo));

            return response;
            
        } catch (Exception e) {
            return new ContactResponse(false, 500, 'Error processing request: ' + e.getMessage(), null);
        }
    }
    
    /**
    * Response wrapper class
    */
    global class ContactResponse {
        global Boolean success;
        global Integer statusCode;
        global String message;
        global ContactInfo contactInfo;

        global ContactResponse(Boolean success, Integer statusCode, String message, ContactInfo contactInfo) {
            this.success = success;
            this.statusCode = statusCode;
            this.message = message;
            this.contactInfo = contactInfo;
        }
    }
    
    /**
        * Contact information wrapper class
        */
    global class ContactInfo {
            global String contactId;
            global String firstName;
            global String lastName;
            global String email;
            global String phone;
            global String homeCountry;
            global String productPlan;
            global PricingInfo pricingInfo;

            global ContactInfo(Contact contact, ProductPricingByCountry__mdt pricing) {
                if(contact == null) {
                    throw new NullPointerException();
                }

                this.contactId = contact.Id;
                this.firstName = contact.FirstName;
                this.lastName = contact.LastName;
                this.email = contact.Email;
                this.phone = contact.Phone;
                this.homeCountry = contact.Home_Country__c;
                this.productPlan = contact.Product__c;

                if (pricing != null) {
                    this.pricingInfo = new PricingInfo();
                    this.pricingInfo.monthlyFee = pricing.Monthly_Fee__c;
                    this.pricingInfo.atmFee = pricing.ATM_Fee__c;
                    this.pricingInfo.cardReplacementCost = pricing.Card_Replacement_Cost__c;
                    this.pricingInfo.validFrom = pricing.Valid_From__c;
                    this.pricingInfo.validTo = pricing.Valid_To__c;
                }
            }
        }
    
    /**
        * Pricing information wrapper class
        */
    global class PricingInfo {
        global Decimal monthlyFee;
        global Decimal atmFee;
        global Decimal cardReplacementCost;
        global Date validFrom;
        global Date validTo;
    }
}