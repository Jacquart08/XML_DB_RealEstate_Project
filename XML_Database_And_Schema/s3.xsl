<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <xsl:output method="xml" indent="yes"/>
    
    <!-- No children not near hospitals and stuff. looking for more affordability -->



    <xsl:param name="maxPrice" select="250000"/> <!-- Maximum price threshold -->
    <xsl:param name="minSize" select="40"/> <!-- Minimum size in square meters -->
    <xsl:param name="maxAttractiveness" select="0.4"/> <!-- Willing to accept properties farther from amenities -->
    <xsl:param name="preferredPropertyTypes" select="'apartment|studio|loft'"/> <!-- Preferred property types -->
    
    <xsl:template match="/">
        <AffordablePropertySearch>
            <SearchParameters>
                <TargetBuyer>No children - Price sensitive</TargetBuyer>
                <MaxPrice><xsl:value-of select="$maxPrice"/>€</MaxPrice>
                <MinSize><xsl:value-of select="$minSize"/>m²</MinSize>
                <MaxAttractivenessScore><xsl:value-of select="$maxAttractiveness"/></MaxAttractivenessScore>
                <Note>Higher attractiveness scores indicate closer proximity to amenities</Note>
            </SearchParameters>
            
            <Results>
                <xsl:apply-templates select="RealEstate_Database/Properties[
                    PriceEstimation &lt;= $maxPrice and 
                    Size &gt;= $minSize and
                    Attractiveness &lt;= $maxAttractiveness and
                    matches(lower-case(TypeOfProperty), $preferredPropertyTypes)
                ]">
                    <xsl:sort select="PriceEstimation div Size" data-type="number" order="ascending"/> <!-- Sort by price per m² ascending -->
                </xsl:apply-templates>
            </Results>
        </AffordablePropertySearch>
    </xsl:template>
    
    <xsl:template match="Properties">
        <Property>
            <BasicInfo>
                <ID><xsl:value-of select="PropertyID"/></ID>
                <Type><xsl:value-of select="TypeOfProperty"/></Type>
                <ContractType><xsl:value-of select="TypeOfContract"/></ContractType>
            </BasicInfo>
            
            <Location>
                <Address>
                    <Street><xsl:value-of select="Address"/></Street>
                    <City><xsl:value-of select="City"/></City>
                    <PostalCode><xsl:value-of select="ZIPCode"/></PostalCode>
                </Address>
                <AttractivenessScore><xsl:value-of select="format-number(Attractiveness, '0.00')"/></AttractivenessScore>
            </Location>
            
            <Specifications>
                <Size><xsl:value-of select="Size"/>m²</Size>
                <Rooms><xsl:value-of select="NumberOfRooms"/></Rooms>
                <Floors><xsl:value-of select="Floors"/></Floors>
                <ExteriorSpace><xsl:value-of select="ExteriorCommodity"/></ExteriorSpace>
                <Heating><xsl:value-of select="HeatingMode"/></Heating>
                <EnergyRating><xsl:value-of select="EnergyDiagnostic"/></EnergyRating>
            </Specifications>
            
            <Pricing>
                <TotalPrice><xsl:value-of select="PriceEstimation"/>€</TotalPrice>
                <PricePerSquareMeter>
                    <xsl:value-of select="format-number(PriceEstimation div Size, '0.00')"/>€/m²
                </PricePerSquareMeter>
            </Pricing>
            
            <AmenityDistances>
                <Supermarket><xsl:value-of select="ClosestSupermarket"/>km</Supermarket>
                <PublicTransport><xsl:value-of select="ClosestPublicTransport"/>km</PublicTransport>
                <School><xsl:value-of select="ClosestSchool"/>km</School>
                <Hospital><xsl:value-of select="ClosestHospital"/>km</Hospital>
            </AmenityDistances>
            
            <Contacts>
                <Agent>
                    <xsl:variable name="agentID" select="AgentID"/>
                    <xsl:for-each select="/RealEstate_Database/RealEstateAgent[AgentID=$agentID]">
                        <Name><xsl:value-of select="concat(AgentFirstName, ' ', AgentName)"/></Name>
                        <Agency><xsl:value-of select="AgencySIRET"/></Agency>
                    </xsl:for-each>
                </Agent>
                <Seller>
                    <xsl:variable name="landlordID" select="LandlordID"/>
                    <xsl:for-each select="/RealEstate_Database/LandLordInformations[LandlordID=$landlordID]">
                        <Name><xsl:value-of select="concat(LandlordFirstName, ' ', LandlordName)"/></Name>
                    </xsl:for-each>
                </Seller>
            </Contacts>
        </Property>
    </xsl:template>
    
    <xsl:template match="text()"/>
    
</xsl:stylesheet>



<!-- Focus on Affordability:

Primary filter is PriceEstimation <= $maxPrice (set to 250,000€ by default)

Sorts results by price per square meter (lowest first)

Calculates and displays value metrics (total price and price/m²)

Avoids Prioritizing Family Amenities:

Sets maxAttractiveness to 0.4 (accepts properties farther from amenities)

While it shows distances to schools/hospitals, they don't affect the filtering

Explicitly notes that higher attractiveness = closer to amenities (which we're avoiding)

Optimized for Child-Free Buyers:

Prefers apartment/studio/loft (typical for single/couple buyers)

Doesn't require minimum room count (unlike family-oriented searches)

No filters for schools or child-friendly features

Value-Centric Approach:

Minimum size requirement (40m²) ensures basic livability

Shows energy rating (important for long-term costs)

Includes exterior space as a bonus, not requirement

Example of what gets selected:

A 45m² apartment for 200,000€ that's 2km from a hospital would be included

A 60m² house for 300,000€ would be excluded (over price limit)

A 50m² apartment next to a school would be included if cheap enough -->