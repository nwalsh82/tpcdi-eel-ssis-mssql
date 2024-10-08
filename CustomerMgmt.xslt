<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:TPCDI="http://www.tpc.org/tpc-di" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <!-- Inline schema definition -->
    <!-- <xsl:template match="/">
        
    </xsl:template> -->


    <!-- Match the root element -->
    <!--<xsl:param name="maxRows" select="200"/>-->
    <xsl:template match="/TPCDI:Actions">
        <root>
            <xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">
                <xsd:element name="root">
                    <xsd:complexType>
                        <xsd:sequence>
                            <xsd:element name="record" maxOccurs="unbounded">
                                <xsd:complexType>
                                    <xsd:attribute name="ActionType" type="xsd:string" use="optional" />
                                    <xsd:attribute name="ActionTS" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_ID" type="xsd:unsignedInt" use="optional" />
                                    <xsd:attribute name="C_TAX_ID" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_GNDR" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_TIER" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_DOB" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_L_NAME" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_F_NAME" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_M_NAME" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_ADLINE1" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_ADLINE2" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_ZIPCODE" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_CITY" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_STATE_PROV" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_CTRY" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_PRIM_EMAIL" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_ALT_EMAIL" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_PHONE_1_CTRY_CODE" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_PHONE_1_AREA_CODE" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_PHONE_1_LOCAL" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_PHONE_1_EXT" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_PHONE_2_CTRY_CODE" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_PHONE_2_AREA_CODE" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_PHONE_2_LOCAL" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_PHONE_2_EXT" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_PHONE_3_CTRY_CODE" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_PHONE_3_AREA_CODE" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_PHONE_3_LOCAL" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_PHONE_3_EXT" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_LCL_TX_ID" type="xsd:string" use="optional" />
                                    <xsd:attribute name="C_NAT_TX_ID" type="xsd:string" use="optional" />
                                    <xsd:attribute name="CA_ID" type="xsd:unsignedInt" use="optional" />
                                    <xsd:attribute name="CA_TAX_ST" type="xsd:string" use="optional" />
                                    <xsd:attribute name="CA_B_ID" type="xsd:string" use="optional" />
                                    <xsd:attribute name="CA_NAME" type="xsd:string" use="optional" />
                                </xsd:complexType>
                            </xsd:element>
                        </xsd:sequence>
                    </xsd:complexType>
                </xsd:element>
            </xsd:schema>
            <!-- <xsl:for-each select="TPCDI:Action[position() &lt;= $maxRows]"> -->
            <xsl:for-each select="TPCDI:Action"> 
                <record>
                    <!-- Flatten Action attributes -->
                    <xsl:attribute name="ActionType"><xsl:choose><xsl:when test="string-length(@ActionType) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="@ActionType"/></xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:attribute name="ActionTS"><xsl:choose><xsl:when test="string-length(@ActionTS) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="@ActionTS"/></xsl:otherwise></xsl:choose></xsl:attribute>

                    <!-- Flatten Customer attributes -->
                    <xsl:attribute name="C_ID"><xsl:choose><xsl:when test="string-length(./Customer/@C_ID) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./Customer/@C_ID"/></xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:attribute name="C_TAX_ID"><xsl:choose><xsl:when test="string-length(./Customer/@C_TAX_ID) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./Customer/@C_TAX_ID"/></xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:attribute name="C_GNDR"><xsl:choose><xsl:when test="string-length(./Customer/@C_GNDR) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./Customer/@C_GNDR"/></xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:attribute name="C_TIER"><xsl:choose><xsl:when test="string-length(./Customer/@C_TIER) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./Customer/@C_TIER"/></xsl:otherwise></xsl:choose></xsl:attribute>
                    <xsl:attribute name="C_DOB"><xsl:choose><xsl:when test="string-length(./Customer/@C_DOB) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./Customer/@C_DOB"/></xsl:otherwise></xsl:choose></xsl:attribute>

                    <!-- Flatten Customer elements -->
                    <xsl:for-each select="./Customer">
                        <xsl:attribute name="C_L_NAME"><xsl:choose><xsl:when test="string-length(./Name/C_L_NAME) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./Name/C_L_NAME"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="C_F_NAME"><xsl:choose><xsl:when test="string-length(./Name/C_F_NAME) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./Name/C_F_NAME"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="C_M_NAME"><xsl:choose><xsl:when test="string-length(./Name/C_M_NAME) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./Name/C_M_NAME"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="C_ADLINE1"><xsl:choose><xsl:when test="string-length(./Address/C_ADLINE1) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./Address/C_ADLINE1"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="C_ADLINE2"><xsl:choose><xsl:when test="string-length(./Address/C_ADLINE2) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./Address/C_ADLINE2"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="C_ZIPCODE"><xsl:choose><xsl:when test="string-length(./Address/C_ZIPCODE) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./Address/C_ZIPCODE"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="C_CITY"><xsl:choose><xsl:when test="string-length(./Address/C_CITY) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./Address/C_CITY"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="C_STATE_PROV"><xsl:choose><xsl:when test="string-length(./Address/C_STATE_PROV) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./Address/C_STATE_PROV"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="C_CTRY"><xsl:choose><xsl:when test="string-length(./Address/C_CTRY) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./Address/C_CTRY"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="C_PRIM_EMAIL"><xsl:choose><xsl:when test="string-length(./ContactInfo/C_PRIM_EMAIL) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./ContactInfo/C_PRIM_EMAIL"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="C_ALT_EMAIL"><xsl:choose><xsl:when test="string-length(./ContactInfo/C_ALT_EMAIL) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./ContactInfo/C_ALT_EMAIL"/></xsl:otherwise></xsl:choose></xsl:attribute>

                        <!-- Map phone number components -->
                        <xsl:attribute name="C_PHONE_1_CTRY_CODE"><xsl:choose><xsl:when test="string-length(./ContactInfo/C_PHONE_1/C_CTRY_CODE) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./ContactInfo/C_PHONE_1/C_CTRY_CODE"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="C_PHONE_1_AREA_CODE"><xsl:choose><xsl:when test="string-length(./ContactInfo/C_PHONE_1/C_AREA_CODE) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./ContactInfo/C_PHONE_1/C_AREA_CODE"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="C_PHONE_1_LOCAL"><xsl:choose><xsl:when test="string-length(./ContactInfo/C_PHONE_1/C_LOCAL) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./ContactInfo/C_PHONE_1/C_LOCAL"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="C_PHONE_1_EXT"><xsl:choose><xsl:when test="string-length(./ContactInfo/C_PHONE_1/C_EXT) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./ContactInfo/C_PHONE_1/C_EXT"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="C_PHONE_2_CTRY_CODE"><xsl:choose><xsl:when test="string-length(./ContactInfo/C_PHONE_2/C_CTRY_CODE) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./ContactInfo/C_PHONE_2/C_CTRY_CODE"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="C_PHONE_2_AREA_CODE"><xsl:choose><xsl:when test="string-length(./ContactInfo/C_PHONE_2/C_AREA_CODE) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./ContactInfo/C_PHONE_2/C_AREA_CODE"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="C_PHONE_2_LOCAL"><xsl:choose><xsl:when test="string-length(./ContactInfo/C_PHONE_2/C_LOCAL) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./ContactInfo/C_PHONE_2/C_LOCAL"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="C_PHONE_2_EXT"><xsl:choose><xsl:when test="string-length(./ContactInfo/C_PHONE_2/C_EXT) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./ContactInfo/C_PHONE_2/C_EXT"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="C_PHONE_3_CTRY_CODE"><xsl:choose><xsl:when test="string-length(./ContactInfo/C_PHONE_3/C_CTRY_CODE) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./ContactInfo/C_PHONE_3/C_CTRY_CODE"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="C_PHONE_3_AREA_CODE"><xsl:choose><xsl:when test="string-length(./ContactInfo/C_PHONE_3/C_AREA_CODE) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./ContactInfo/C_PHONE_3/C_AREA_CODE"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="C_PHONE_3_LOCAL"><xsl:choose><xsl:when test="string-length(./ContactInfo/C_PHONE_3/C_LOCAL) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./ContactInfo/C_PHONE_3/C_LOCAL"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="C_PHONE_3_EXT"><xsl:choose><xsl:when test="string-length(./ContactInfo/C_PHONE_3/C_EXT) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./ContactInfo/C_PHONE_3/C_EXT"/></xsl:otherwise></xsl:choose></xsl:attribute>

                        <xsl:attribute name="C_LCL_TX_ID"><xsl:choose><xsl:when test="string-length(./TaxInfo/C_LCL_TX_ID) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./TaxInfo/C_LCL_TX_ID"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="C_NAT_TX_ID"><xsl:choose><xsl:when test="string-length(./TaxInfo/C_NAT_TX_ID) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./TaxInfo/C_NAT_TX_ID"/></xsl:otherwise></xsl:choose></xsl:attribute>
                    </xsl:for-each>

                    <!-- Flatten Account elements -->
                    <xsl:for-each select="./Customer/Account">
                        <xsl:attribute name="CA_ID"><xsl:choose><xsl:when test="string-length(@CA_ID) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="@CA_ID"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="CA_TAX_ST"><xsl:choose><xsl:when test="string-length(@CA_TAX_ST) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="@CA_TAX_ST"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="CA_B_ID"><xsl:choose><xsl:when test="string-length(./CA_B_ID) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./CA_B_ID"/></xsl:otherwise></xsl:choose></xsl:attribute>
                        <xsl:attribute name="CA_NAME"><xsl:choose><xsl:when test="string-length(./CA_NAME) = 0">`</xsl:when><xsl:otherwise><xsl:value-of select="./CA_NAME"/></xsl:otherwise></xsl:choose></xsl:attribute>
                    </xsl:for-each>
                </record>
            </xsl:for-each>
        </root>
    </xsl:template>
</xsl:stylesheet>