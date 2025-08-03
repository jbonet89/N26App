import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getProductPricing from '@salesforce/apex/ProductPricingService.getProductPricing';
import productCountryNoInfo from '@salesforce/label/c.Error_Product_Country_No_Info'; 

const FIELDS = [
    'Case.ContactId',
    'Case.Contact.Home_Country__c',
    'Case.Contact.Product__c'
];

export default class LwcCustomerProductInformation extends LightningElement {
    @api recordId; // Case ID

    country;
    product;
    pricingData;
    error;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredCase({ error, data }) {
        if (data) {
            const contactCountry = data.fields.Contact.value.fields.Home_Country__c.value;
            const contactProduct = data.fields.Contact.value.fields.Product__c.value;

            this.country = contactCountry;
            this.product = contactProduct;
            this.fetchPricing();
        } else if (error) {
            this.error = error;
            this.pricingData = null;
        }
    }

    fetchPricing() {
        getProductPricing({
            productPlan: this.product,
            countryCode: this.country
        })
            .then(result => {
                if(!result) {
                    this.error = productCountryNoInfo;
                    this.pricingData = null;
                    return;
                }
                this.pricingData = result;
                this.error = null;
            })
            .catch(error => {
                this.error = error;
                this.pricingData = null;
            });
    }
}