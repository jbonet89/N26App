@isTest
public with sharing class ContactTestDataFactory {
    /**
     * Creates a test contact with the specified parameters.
     * @param uuid The UUID of the contact.
     * @param firstName The first name of the contact.
     * @param lastName The last name of the contact.
     * @param email The email address of the contact.
     * @param phone The phone number of the contact.
     * @param homeCountry The home country of the contact.
     * @param productPlan The product plan associated with the contact.
     * @param doInsert Whether to insert the contact into the database.
     * @return The created Contact object.
     */
    public static Contact createTestContact(String uuid, String firstName, String lastName, String email, String phone, String homeCountry, String productPlan, Boolean doInsert) {
        Contact testContact = new Contact(
            FirstName = firstName,
            LastName = lastName,
            Email = email,
            Phone = phone,
            Home_Country__c = homeCountry,
            Product__c = productPlan,
            UUID__c = uuid
        );
        if (doInsert) {
            insert testContact;
        }
        return testContact;
    }
}