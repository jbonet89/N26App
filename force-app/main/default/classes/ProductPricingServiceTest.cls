@isTest
private class ProductPricingServiceTest {


@IsTest
    static void testGetProductPricing() {
        // Test with a valid product plan and country code (BLACK)
        ProductPricingByCountry__mdt config1 = ProductPricingService.getProductPricing('Black', 'DE');
        System.assertEquals('Black', config1.Product_Plan__c);
        System.assertEquals('DE', config1.Country_Code__c);

        // Test with a valid product plan and country code (METAL)
        ProductPricingByCountry__mdt config2 = ProductPricingService.getProductPricing('Metal', 'UK');
        System.assertEquals('Metal', config2.Product_Plan__c);
        System.assertEquals('UK', config2.Country_Code__c);

        // Test with a valid product plan and country code (Default)
        ProductPricingByCountry__mdt config3 = ProductPricingService.getProductPricing('Standard', 'JP');
        System.assertEquals('Standard', config3.Product_Plan__c);
        System.assertEquals('JP', config3.Country_Code__c);

        // Test with an invalid product plan and country code
        ProductPricingByCountry__mdt config4 = ProductPricingService.getProductPricing('InvalidPlan', 'XX');
        System.assertEquals(null, config4);
    }

}