<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="yes"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Real Estate Transaction Invoice</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 0; padding: 20px; color: #333; }
                    .invoice-container { max-width: 800px; margin: 0 auto; border: 1px solid #ddd; padding: 30px; }
                    .header { text-align: center; margin-bottom: 30px; border-bottom: 1px solid #eee; padding-bottom: 20px; }
                    .header h1 { margin: 0; color: #2c3e50; }
                    .header p { margin: 5px 0; }
                    .details { display: flex; justify-content: space-between; margin-bottom: 30px; }
                    .section { margin-bottom: 20px; }
                    .section h2 { border-bottom: 1px solid #eee; padding-bottom: 5px; color: #2c3e50; }
                    table { width: 100%; border-collapse: collapse; margin: 20px 0; }
                    th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
                    th { background-color: #f8f9fa; }
                    .totals { float: right; width: 300px; margin-top: 20px; }
                    .totals table { width: 100%; }
                    .footer { margin-top: 50px; text-align: center; font-size: 0.9em; color: #777; border-top: 1px solid #eee; padding-top: 20px; }
                    .signature { margin-top: 50px; display: flex; justify-content: space-between; }
                    .signature div { width: 45%; border-top: 1px solid #333; padding-top: 10px; }
                </style>
            </head>
            <body>
                <div class="invoice-container">
                    <div class="header">
                        <h1>Real Estate Transaction Invoice</h1>
                        <p>Invoice Date: <xsl:value-of select="format-date(RealEstate_Database/Sales_Table/Sales/InvoiceDate, '[D01]/[M01]/[Y0001]')"/></p>
                        <p>Invoice #: <xsl:value-of select="RealEstate_Database/Sales_Table/Sales/InvoiceID"/></p>
                    </div>
                    
                    <div class="details">
                        <div class="from">
                            <h3>From:</h3>
                            <xsl:apply-templates select="RealEstate_Database/RealEstateAgent/Agent[AgentID = /RealEstate_Database/Sales_Table/Sales/AgentID]"/>
                        </div>
                        <div class="to">
                            <h3>To:</h3>
                            <xsl:apply-templates select="RealEstate_Database/BuyerInformations/Buyer[BuyerID = /RealEstate_Database/Sales_Table/Sales/BuyerID]"/>
                        </div>
                    </div>
                    
                    <div class="section">
                        <h2>Property Details</h2>
                        <xsl:apply-templates select="RealEstate_Database/Properties/Property[PropertyID = /RealEstate_Database/Sales_Table/Sales/PropertyID]"/>
                    </div>
                    
                    <div class="section">
                        <h2>Transaction Details</h2>
                        <table>
                            <tr>
                                <th>Description</th>
                                <th>Amount</th>
                            </tr>
                            <tr>
                                <td>Property Price</td>
                                <td><xsl:value-of select="format-number(RealEstate_Database/Sales_Table/Sales/Price, '€#,##0.00')"/></td>
                            </tr>
                            <tr>
                                <td>Agency Fee (<xsl:value-of select="format-number(RealEstate_Database/Sales_Table/Sales/AgentPercentage * 100, '0.00')"/>%)</td>
                                <td><xsl:value-of select="format-number(RealEstate_Database/Sales_Table/Sales/Price * RealEstate_Database/Sales_Table/Sales/AgentPercentage, '€#,##0.00')"/></td>
                            </tr>
                            <tr>
                                <td>Notary Fee (<xsl:value-of select="format-number(RealEstate_Database/Sales_Table/Sales/NotaryPercentage * 100, '0.00')"/>%)</td>
                                <td><xsl:value-of select="format-number(RealEstate_Database/Sales_Table/Sales/Price * RealEstate_Database/Sales_Table/Sales/NotaryPercentage, '€#,##0.00')"/></td>
                            </tr>
                        </table>
                        
                        <div class="totals">
                            <table>
                                <tr>
                                    <th>Total Amount Due:</th>
                                    <td><xsl:value-of select="format-number(RealEstate_Database/Sales_Table/Sales/FinalPrice, '€#,##0.00')"/></td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    
                    <div class="section">
                        <h2>Notary Information</h2>
                        <xsl:apply-templates select="RealEstate_Database/NotaryInformations/Notary[NotaryID = /RealEstate_Database/Sales_Table/Sales/NotaryID]"/>
                    </div>
                    
                    <div class="signature">
                        <div>
                            <p>Buyer's Signature</p>
                        </div>
                        <div>
                            <p>Agent's Signature</p>
                        </div>
                    </div>
                    
                    <div class="footer">
                        <p>Thank you for your business!</p>
                        <p>This invoice is computer generated and does not require a signature.</p>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="Agent">
        <p><xsl:value-of select="AgentFirstName"/>&#160;<xsl:value-of select="AgentName"/></p>
        <p>Agency SIRET: <xsl:value-of select="AgencySIRET"/></p>
    </xsl:template>
    
    <xsl:template match="Buyer">
        <p><xsl:value-of select="BuyerFirstName"/>&#160;<xsl:value-of select="BuyerName"/></p>
        <p><xsl:value-of select="BuyerAddress"/></p>
        <p><xsl:value-of select="BuyerZIPcode"/>&#160;<xsl:value-of select="BuyerCity"/></p>
    </xsl:template>
    
    <xsl:template match="Property">
        <table>
            <tr>
                <th>Address</th>
                <td><xsl:value-of select="Address"/>, <xsl:value-of select="ZIPCode"/>&#160;<xsl:value-of select="City"/></td>
            </tr>
            <tr>
                <th>Type</th>
                <td><xsl:value-of select="TypeOfProperty"/> (<xsl:value-of select="TypeOfContract"/>)</td>
            </tr>
            <tr>
                <th>Size</th>
                <td><xsl:value-of select="Size"/> m²</td>
            </tr>
            <tr>
                <th>Rooms</th>
                <td><xsl:value-of select="NumberOfRooms"/></td>
            </tr>
            <tr>
                <th>Energy Rating</th>
                <td><xsl:value-of select="EnergyDiagnostic"/></td>
            </tr>
        </table>
    </xsl:template>
    
    <xsl:template match="Notary">
        <p><xsl:value-of select="NotaryFirstName"/>&#160;<xsl:value-of select="NotaryName"/></p>
        <p><xsl:value-of select="NotaryAddress"/></p>
        <p><xsl:value-of select="NotaryZIPcode"/>&#160;<xsl:value-of select="NotaryCity"/></p>
        <p>SIRET: <xsl:value-of select="NotarySIRET"/></p>
    </xsl:template>
    
    <!-- Date formatting function for XSLT 1.0 -->
    <xsl:template name="format-date">
        <xsl:param name="date"/>
        <xsl:value-of select="concat(substring($date, 9, 2), '/', substring($date, 6, 2), '/', substring($date, 1, 4))"/>
    </xsl:template>
</xsl:stylesheet>