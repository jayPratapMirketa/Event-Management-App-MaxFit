@isTest
// Annotation indicating that this is a test class
public class CustomPricebookTest {

    // Annotation indicating that this is a test method
    @isTest
    static void customPricebookTest(){

        // Sets the HTTP callout mock for the test
        Test.setMock(HttpCalloutMock.class, new CustomPricebookMock());

        // Calls the method being tested
        List<PricebookEntry> priceEntries = CustomPricebook.priceBookGetCallout();

        // Gets the first PricebookEntry returned by the method
        PricebookEntry PriceEntry = priceEntries[0];

        // Gets the product associated with the PricebookEntry
        Product2 product= [SELECT ID, Name, ProductCode FROM Product2 WHERE Id=: PriceEntry.Product2Id];

        // Gets the pricebook associated with the PricebookEntry
        Pricebook2 priceBook= [SELECT ID, Name FROM Pricebook2 WHERE Id=: PriceEntry.Pricebook2Id LIMIT 1];

        // Asserts that there are 2 PricebookEntries returned
        System.assertEquals(2, priceEntries.size());

        // Asserts that the unit price of the first PricebookEntry is 109.95
        System.assertEquals(109.95, PriceEntry.UnitPrice);

        // Asserts that the name of the pricebook associated with the first PricebookEntry is 'Jay Price Book'
        System.assertEquals('Jay Price Book', priceBook.Name);

        // Asserts that the product code of the product associated with the first PricebookEntry is '1'
        System.assertEquals('1', product.ProductCode);

        // Asserts that the name of the product associated with the first PricebookEntry is 'Fjallraven -Foldsack No. 1 Backpack, Fits 15 Laptops'
        System.assertEquals('Fjallraven -Foldsack No. 1 Backpack, Fits 15 Laptops', product.Name);
    }
}