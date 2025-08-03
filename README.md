# Salesforce Product Pricing by Country Package

This package provides a complete implementation to display product fees and pricing based on a customer's country and banking plan. It uses Salesforce Custom Metadata Types, Apex services, and Lightning Web Components (LWC).

---

## 📦 Package Contents

### 1. **Apex Classes**

| Class Name                 | Description                                                                  |
|---------------------------|------------------------------------------------------------------------------|
| `ContactRestService`      | A REST API exposing contact-related data, including pricing configuration.  |
| `ContactRestServiceTest`  | Unit tests for the REST API.                                                 |
| `ContactTestDataFactory`  | Test data factory for generating contacts.                                   |
| `ProductPricingService`   | Apex service that retrieves pricing metadata based on product and country.   |
| `ProductPricingServiceTest` | Unit tests for `ProductPricingService`, including fallback behavior.        |

---

### 2. **Custom Labels**

| Label                        | Purpose                                                  |
|-----------------------------|----------------------------------------------------------|
| `Error_Product_Country_No_Info` | Error message shown when no matching product/country config is found. |

---

### 3. **Custom Metadata**

| Metadata Type                   | Description                                                                |
|--------------------------------|----------------------------------------------------------------------------|
| `ProductPricingByCountry__mdt` | Stores monthly fees, card replacement cost, and ATM fees per plan/country. |
| `*`                            | Includes all records needed, including dated and fallback (default) entries. |

Each record can include optional `Valid_From__c` and `Valid_To__c` fields to define versioned pricing (e.g. for 2025), and fallback records with no dates.

---

### 4. **Custom Object**

| Custom Object                   | Description                                               |
|---------------------------------|-----------------------------------------------------------|
| `ProductPricingByCountry__mdt`  | Declaration of the metadata type used to store pricing info. |

---

### 5. **Lightning Web Component**

| Component                      | Description                                                                 |
|-------------------------------|-----------------------------------------------------------------------------|
| `lwcCustomerProductInformation` | A case page component that shows product pricing info for the related contact. |

This LWC:
- Reads `ContactId` from the `Case` object.
- Retrieves `Product__c` and `Home_Country__c` from the related contact.
- Calls `ProductPricingService` to fetch the relevant pricing config.
- Displays the data in a `lightning-card`.

---

## ✅ Features Covered

- Dynamic pricing shown based on contact's country and product.
- Support for versioned configurations (e.g. pricing for 2024, 2025).
- Automatic fallback to default pricing when no date-matched record exists.
- Supports LWC display and external system integration via REST.
- Fully tested with Apex test classes and data factories.

---

## 🧪 API Version

The package uses Salesforce API version **64.0**.

---

## 📁 Recommended Project Structure

This is intended to follow the Salesforce DX format:

