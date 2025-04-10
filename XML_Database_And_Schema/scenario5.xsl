<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <!-- Define the output format as PDF -->
  <xsl:output method="xml" indent="yes"/>

  <!-- Match the root element and apply templates for invoice generation -->
  <xsl:template match="/">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="invoice-page" page-height="29.7cm" page-width="21cm" margin="2cm">
          <fo:region-body/>
        </fo:simple-page-master>
      </fo:layout-master-set>

      <fo:page-sequence master-reference="invoice-page">
        <fo:flow flow-name="xsl-region-body">
          <xsl:apply-templates select="RealEstate_Database/Sales_Table/Sales"/>
        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>

  <!-- Template to match each sale and generate an invoice -->
  <xsl:template match="Sales">
    <fo:block font-size="16pt" font-weight="bold" text-align="center" space-after="12pt">
      Property Sale Invoice
    </fo:block>

    <fo:block font-size="12pt" space-after="12pt">
      <fo:table table-layout="fixed" width="100%">
        <fo:table-column column-width="50%"/>
        <fo:table-column column-width="50%"/>
        <fo:table-body>
          <fo:table-row>
            <fo:table-cell>
              <fo:block><xsl:text>Invoice ID: </xsl:text><xsl:value-of select="InvoiceID"/></fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block><xsl:text>Date: </xsl:text><xsl:value-of select="InvoiceDate"/></fo:block>
            </fo:table-cell>
          </fo:table-row>
          <fo:table-row>
            <fo:table-cell>
              <fo:block><xsl:text>Type of Contract: </xsl:text><xsl:value-of select="TypeOfContract"/></fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
    </fo:block>

    <fo:block font-size="12pt" space-after="12pt">
      <fo:block font-weight="bold">Property Details</fo:block>
      <xsl:variable name="property" select="../../Properties/Property[PropertyID=current()/PropertyID]"/>
      <fo:block><xsl:text>Address: </xsl:text><xsl:value-of select="$property/Address"/>, <xsl:value-of select="$property/City"/>, <xsl:value-of select="$property/ZIPCode"/></fo:block>
      <fo:block><xsl:text>Type of Property: </xsl:text><xsl:value-of select="$property/TypeOfProperty"/></fo:block>
      <fo:block><xsl:text>Size: </xsl:text><xsl:value-of select="$property/Size"/> sqm</fo:block>
      <fo:block><xsl:text>Price Estimation: </xsl:text><xsl:value-of select="$property/PriceEstimation"/></fo:block>
    </fo:block>

    <fo:block font-size="12pt" space-after="12pt">
      <fo:block font-weight="bold">Parties Involved</fo:block>
      <fo:table table-layout="fixed" width="100%">
        <fo:table-column column-width="50%"/>
        <fo:table-column column-width="50%"/>
        <fo:table-body>
          <fo:table-row>
            <fo:table-cell>
              <fo:block font-weight="bold">Seller</fo:block>
              <xsl:variable name="landlord" select="../../LandLordInformations/Landlord[LandlordID=current()/LandlordID]"/>
              <fo:block><xsl:text>Name: </xsl:text><xsl:value-of select="$landlord/LandlordName"/> <xsl:value-of select="$landlord/LandlordFirstName"/></fo:block>
              <fo:block><xsl:text>Address: </xsl:text><xsl:value-of select="$landlord/LandlordAddress"/>, <xsl:value-of select="$landlord/LandlordCity"/>, <xsl:value-of select="$landlord/LandlordZIPcode"/></fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block font-weight="bold">Buyer</fo:block>
              <xsl:variable name="buyer" select="../../BuyerInformations/Buyer[BuyerID=current()/BuyerID]"/>
              <fo:block><xsl:text>Name: </xsl:text><xsl:value-of select="$buyer/BuyerName"/> <xsl:value-of select="$buyer/BuyerFirstName"/></fo:block>
              <fo:block><xsl:text>Address: </xsl:text><xsl:value-of select="$buyer/BuyerAddress"/>, <xsl:value-of select="$buyer/BuyerCity"/>, <xsl:value-of select="$buyer/BuyerZIPcode"/></fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
    </fo:block>

    <fo:block font-size="12pt" space-after="12pt">
      <fo:block font-weight="bold">Agent and Notary Details</fo:block>
      <fo:table table-layout="fixed" width="100%">
        <fo:table-column column-width="50%"/>
        <fo:table-column column-width="50%"/>
        <fo:table-body>
          <fo:table-row>
            <fo:table-cell>
              <fo:block font-weight="bold">Agent</fo:block>
              <xsl:variable name="agent" select="../../RealEstateAgent/Agent[AgentID=current()/AgentID]"/>
              <fo:block><xsl:text>Name: </xsl:text><xsl:value-of select="$agent/AgentName"/> <xsl:value-of select="$agent/AgentFirstName"/></fo:block>
              <fo:block><xsl:text>Agency SIRET: </xsl:text><xsl:value-of select="$agent/AgencySIRET"/></fo:block>
            </fo:table-cell>
            <fo:table-cell>
              <fo:block font-weight="bold">Notary</fo:block>
              <xsl:variable name="notary" select="../../NotaryInformations/Notary[NotaryID=current()/NotaryID]"/>
              <fo:block><xsl:text>Name: </xsl:text><xsl:value-of select="$notary/NotaryName"/> <xsl:value-of select="$notary/NotaryFirstName"/></fo:block>
              <fo:block><xsl:text>Notary SIRET: </xsl:text><xsl:value-of select="$notary/NotarySIRET"/></fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
    </fo:block>

    <fo:block font-size="12pt" space-after="12pt">
      <fo:block font-weight="bold">Financial Details</fo:block>
      <fo:block><xsl:text>Sale Price: </xsl:text><xsl:value-of select="Price"/></fo:block>
      <fo:block><xsl:text>Notary Percentage: </xsl:text><xsl:value-of select="NotaryPercentage"/></fo:block>
      <fo:block><xsl:text>Agent Percentage: </xsl:text><xsl:value-of select="AgentPercentage"/></fo:block>
      <fo:block><xsl:text>Final Price: </xsl:text><xsl:value-of select="FinalPrice"/></fo:block>
    </fo:block>

    <fo:block text-align="center" font-size="10pt">
      Thank you for your business!
    </fo:block>
  </xsl:template>

</xsl:stylesheet>
