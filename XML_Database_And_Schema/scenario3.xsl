<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <xsl:output method="xml" indent="yes"/>

    <!-- PARAMETERS: Adjust these values to change search criteria -->
    <xsl:param name="maxPrice" select="250000"/>       <!-- Maximum acceptable price in euros -->
    <xsl:param name="minSize" select="40"/>            <!-- Minimum size in square meters -->
    <xsl:param name="maxAttractiveness" select="0.4"/> <!-- Higher values mean closer to amenities -->
    <xsl:param name="preferredPropertyTypes" select="'apartment|studio|loft'"/> <!-- Regex pattern for property types -->

    <!-- MAIN TEMPLATE: Entry point for transformation -->
    <xsl:template match="/">
        <!-- Using RealEstate_Database as root since it's the defined root element -->
        <RealEstate_Database>
            <!-- Create a new Properties element to hold our filtered results -->
            <Properties>
                <xsl:comment> Filtered properties matching criteria for price-sensitive buyers </xsl:comment>
                <xsl:comment> Max Price: <xsl:value-of select="$maxPrice"/> | Min Size: <xsl:value-of select="$minSize"/> </xsl:comment>

                <!-- PROCESS PROPERTIES THAT MATCH OUR CRITERIA -->
                <xsl:apply-templates select="RealEstate_Database/Properties/Property[
                    PriceEstimation &lt;= $maxPrice and
                    Size &gt;= $minSize and
                    Attractiveness &lt;= $maxAttractiveness and
                    (contains(translate(TypeOfProperty, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'apartment') or
                     contains(translate(TypeOfProperty, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'studio') or
                     contains(translate(TypeOfProperty, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'loft'))
                ]">
                    <!-- Sort by price per square meter (cheapest first) -->
                    <xsl:sort select="PriceEstimation div Size" data-type="number" order="ascending"/>
                </xsl:apply-templates>
            </Properties>
        </RealEstate_Database>
    </xsl:template>

    <!-- PROPERTY TEMPLATE: Formats each matching property (using exact schema-defined structure) -->
    <xsl:template match="Property">
        <Property>
            <!-- All these elements are defined in the schema's PropertyType complexType -->
            <PropertyID><xsl:value-of select="PropertyID"/></PropertyID>
            <AgentID><xsl:value-of select="AgentID"/></AgentID>
            <LandlordID><xsl:value-of select="LandlordID"/></LandlordID>
            <TypeOfContract><xsl:value-of select="TypeOfContract"/></TypeOfContract>
            <TypeOfProperty><xsl:value-of select="TypeOfProperty"/></TypeOfProperty>
            <Floors><xsl:value-of select="Floors"/></Floors>
            <ExteriorCommodity><xsl:value-of select="ExteriorCommodity"/></ExteriorCommodity>
            <HeatingMode><xsl:value-of select="HeatingMode"/></HeatingMode>
            <EnergyDiagnostic><xsl:value-of select="EnergyDiagnostic"/></EnergyDiagnostic>
            <Address><xsl:value-of select="Address"/></Address>
            <City><xsl:value-of select="City"/></City>
            <ZIPCode><xsl:value-of select="ZIPCode"/></ZIPCode>
            <Size><xsl:value-of select="Size"/></Size>
            <NumberOfRooms><xsl:value-of select="NumberOfRooms"/></NumberOfRooms>
            <PriceEstimation><xsl:value-of select="PriceEstimation"/></PriceEstimation>
            <Attractiveness><xsl:value-of select="Attractiveness"/></Attractiveness>
            <ClosestSupermarket><xsl:value-of select="ClosestSupermarket"/></ClosestSupermarket>
            <ClosestPublicTransport><xsl:value-of select="ClosestPublicTransport"/></ClosestPublicTransport>
            <ClosestSchool><xsl:value-of select="ClosestSchool"/></ClosestSchool>
            <ClosestHospital><xsl:value-of select="ClosestHospital"/></ClosestHospital>

            <!-- Calculated fields as comments since they're not in schema -->
            <xsl:comment> pricePerSquareMeter: <xsl:value-of select="format-number(PriceEstimation div Size, '#,##0.00')"/>€/m² </xsl:comment>
            <xsl:comment> formattedPrice: <xsl:value-of select="format-number(PriceEstimation, '#,##0')"/>€ </xsl:comment>
        </Property>
    </xsl:template>

    <!-- SUPPRESS ALL UNMATCHED TEXT -->
    <xsl:template match="text()"/>

</xsl:stylesheet>
