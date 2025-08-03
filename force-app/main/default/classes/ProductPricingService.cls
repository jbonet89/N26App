public with sharing class ProductPricingService {

    /**
     * Retrieves the product pricing configuration for a given product plan and country code.
     * The method checks the validity of the configuration based on the current date.
     *
     * @param productPlan The product plan identifier.
     * @param countryCode The country code for which the pricing is requested.
     * @return ProductPricingByCountry__mdt The matching product pricing configuration, or null if not found.
     */
    @AuraEnabled(cacheable=true)
    public static ProductPricingByCountry__mdt getProductPricing(String productPlan, String countryCode) {
        Date today = Date.today();

        List<ProductPricingByCountry__mdt> configs = [
            SELECT Product_Plan__c, Country_Code__c, Monthly_Fee__c, ATM_Fee__c, Card_Replacement_Cost__c,
                   Valid_From__c, Valid_To__c
            FROM ProductPricingByCountry__mdt
            WHERE Product_Plan__c = :productPlan AND Country_Code__c = :countryCode
            ORDER BY Valid_From__c DESC NULLS LAST
        ];
        
        ProductPricingByCountry__mdt defaultConfig;

        for (ProductPricingByCountry__mdt config : configs) {
            Boolean hasFrom = config.Valid_From__c != null;
            Boolean hasTo = config.Valid_To__c != null;

            if (hasFrom || hasTo) {
                if ((config.Valid_From__c == null || config.Valid_From__c <= today) &&
                    (config.Valid_To__c == null || config.Valid_To__c >= today)) {
                    return config; // Priority: valid by date range
                }
            } else {
                defaultConfig = config; // Default: if no date constraints are defined
            }
        }

        return defaultConfig;
    }
}