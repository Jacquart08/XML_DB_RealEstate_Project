<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <xsl:output method="xml" indent="yes"/>
    
    <!-- with children near hostpitals, schools, train stations -->


    <xsl:param name="hasChildren" select="true()"/>
    <xsl:param name="maxDistanceToSchool" select="1.0"/> <!-- in km -->
    <xsl:param name="maxDistanceToHospital" select="2.0"/> <!-- in km -->
    <xsl:param name="maxDistanceToTransport" select="0.5"/> <!-- in km -->
    <xsl:param name="minAttractiveness" select="0.7"/> <!-- on a scale of 0 to 1 -->
    
    <xsl:template match="/">
        <PropertySearchResults>
            <SearchCriteria>
                <HasChildren><xsl:value-of select="$hasChildren"/></HasChildren>
                <MaxDistanceToSchool><xsl:value-of select="$maxDistanceToSchool"/> km</MaxDistanceToSchool>
                <MaxDistanceToHospital><xsl:value-of select="$maxDistanceToHospital"/> km</MaxDistanceToHospital>
                <MaxDistanceToTransport><xsl:value-of select="$maxDistanceToTransport"/> km</MaxDistanceToTransport>
                <MinAttractiveness><xsl:value-of select="$minAttractiveness"/></MinAttractiveness>
            </SearchCriteria>
            
            <xsl:apply-templates select="RealEstate_Database/Properties"/>
        </PropertySearchResults>
    </xsl:template>
    
    <xsl:template match="Properties">
        <xsl:if test="ClosestSchool &lt;= $maxDistanceToSchool and 
                      ClosestHospital &lt;= $maxDistanceToHospital and 
                      ClosestPublicTransport &lt;= $maxDistanceToTransport and
                      Attractiveness &gt;= $minAttractiveness">
            <Property>
                <PropertyID><xsl:value-of select="PropertyID"/></PropertyID>
                <Type><xsl:value-of select="TypeOfProperty"/></Type>
                <Address>
                    <Street><xsl:value-of select="Address"/></Street>
                    <City><xsl:value-of select="City"/></City>
                    <ZIP><xsl:value-of select="ZIPCode"/></ZIP>
                </Address>
                <Details>
                    <Size><xsl:value-of select="Size"/> m²</Size>
                    <Rooms><xsl:value-of select="NumberOfRooms"/></Rooms>
                    <Floors><xsl:value-of select="Floors"/></Floors>
                    <Price><xsl:value-of select="PriceEstimation"/> €</Price>
                </Details>
                <Facilities>
                    <SchoolDistance><xsl:value-of select="ClosestSchool"/> km</SchoolDistance>
                    <HospitalDistance><xsl:value-of select="ClosestHospital"/> km</HospitalDistance>
                    <TransportDistance><xsl:value-of select="ClosestPublicTransport"/> km</TransportDistance>
                    <SupermarketDistance><xsl:value-of select="ClosestSupermarket"/> km</SupermarketDistance>
                </Facilities>
                <AttractivenessScore><xsl:value-of select="format-number(Attractiveness, '0.00')"/></AttractivenessScore>
                
                <!-- Get agent information -->
                <Agent>
                    <xsl:variable name="agentID" select="AgentID"/>
                    <xsl:for-each select="/RealEstate_Database/RealEstateAgent[AgentID=$agentID]">
                        <Name><xsl:value-of select="concat(AgentFirstName, ' ', AgentName)"/></Name>
                        <Contact>Agency SIRET: <xsl:value-of select="AgencySIRET"/></Contact>
                    </xsl:for-each>
                </Agent>
            </Property>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="text()"/>
    
</xsl:stylesheet>



<!-- 


Parameters: Sets search criteria parameters that can be adjusted:

hasChildren: Boolean to indicate if buyer has children

Distance thresholds for schools, hospitals, and public transport

Minimum attractiveness score

Output Structure: Creates a PropertySearchResults element containing:

The search criteria used

Matching properties that meet all criteria

Property Filtering: Only includes properties where:

School is within the specified distance

Hospital is within the specified distance

Public transport is within the specified distance

Attractiveness score meets the minimum threshold

Property Details: For each matching property, includes:

Basic property information (ID, type, address)

Size, room count, floors, and price

Distances to key facilities

Attractiveness score

Contact information for the responsible agent



 -->
