<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>

    <!-- Seller contacts agent to sell their property -->
    <xsl:template match="/RealEstate_Database">
        <RealEstate_Database>
            <!-- We'll use a standard element from our schema - we're creating a focused view of the data -->
            <Properties>
                <xsl:for-each select="Properties/Property">
                    <xsl:variable name="currentPropertyID" select="PropertyID"/>
                    <xsl:variable name="landlord" select="../../LandLordInformations/Landlord[PropertyID=$currentPropertyID]"/>
                    <xsl:variable name="agent" select="../../RealEstateAgent/Agent[PropertyID=$currentPropertyID]"/>

                    <Property>
                        <PropertyID><xsl:value-of select="PropertyID"/></PropertyID>
                        <TypeOfContract>Sales</TypeOfContract>
                        <TypeOfProperty><xsl:value-of select="TypeOfProperty"/></TypeOfProperty>
                        <Address><xsl:value-of select="Address"/></Address>
                        <City><xsl:value-of select="City"/></City>
                        <ZIPCode><xsl:value-of select="ZIPCode"/></ZIPCode>
                        <Size><xsl:value-of select="Size"/></Size>
                        <PriceEstimation><xsl:value-of select="PriceEstimation"/></PriceEstimation>
                        <SellerName>
                            <xsl:value-of select="$landlord/LandlordFirstName"/><xsl:text> </xsl:text><xsl:value-of select="$landlord/LandlordName"/>
                        </SellerName>
                        <SellerContact>
                            <xsl:value-of select="$landlord/LandlordAddress"/>, <xsl:value-of select="$landlord/LandlordCity"/>, <xsl:value-of select="$landlord/LandlordZIPcode"/>
                        </SellerContact>
                        <AgentName>
                            <xsl:value-of select="$agent/AgentFirstName"/><xsl:text> </xsl:text><xsl:value-of select="$agent/AgentName"/>
                        </AgentName>
                        <AgencyID><xsl:value-of select="$agent/AgencySIRET"/></AgencyID>
                    </Property>
                </xsl:for-each>
            </Properties>

            <xsl:comment>
                This document represents the scenario where a seller contacts an agent to sell their property.
                The data has been extracted from the original database to highlight the relevant information.
            </xsl:comment>
        </RealEstate_Database>
    </xsl:template>
</xsl:stylesheet>
