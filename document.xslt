<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="1.0">
  <xsl:output method="html" doctype-public="XSLT-compat" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>
  <xsl:strip-space elements="*"/>
  <xsl:template match="/Document">
    <html>
      <head>
        <title>ISO 20022 message</title>
        <link rel="stylesheet" type="text/css" href="document.css"/>
        <meta charset="UTF-8"/>
      </head>
      <body>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>
  <!-- -->
  <xsl:template match="AccptrAuthstnReq">
    <h2>Acceptor Authorisation Request</h2>
    <span class="left">
      v.<xsl:value-of select="Hdr/PrtcolVrsn"/>
    </span>
    <span class="right">
      №<xsl:value-of select="Hdr/XchgId"/>
    </span>
    <br/>
    <time class="right">
      <xsl:value-of select="Hdr/CreDtTm"/>
    </time>
    <span class="left">
      <xsl:apply-templates select="Hdr/MsgFctn" mode="y"/>
      (capture: <xsl:value-of select="AuthstnReq/Tx/TxCaptr"/>)
    </span>
    <br/>
    <blockquote cite="http://www.iso20022.org/">
      This message is sent to check with the issuer (or its agent) that the
      account associated to the card has the resources to fund the payment.
      This checking will include validation of the card data and any additional
      transaction data provided.
    </blockquote>
    <xsl:apply-templates mode="Document"/>
  </xsl:template>
  <xsl:template match="AccptrAuthstnReq[not(SctyTrlr)]">
    <hr/>
    No security trailer found
  </xsl:template>
  <!-- -->
  <xsl:template match="AuthstnReq" mode="Document">
    <h3>Authorisation Request</h3>
    <xsl:apply-templates select="Tx"/>
  </xsl:template>
  <xsl:template match="AuthstnReq/Tx">
    <h4>Transaction</h4>
    <dl>
    <xsl:apply-templates select="TxId"/>
  </dl>
  </xsl:template>
  <!-- -->
  <xsl:template match="Tx/TxId">
    <dt>transaction id</dt>
    <dd>
      <xsl:value-of select="TxRef"/>
    </dd>
    <dd>
      <time>
        <xsl:value-of select="TxDtTm"/>
      </time>
    </dd>
  </xsl:template>
  <!-- -->
  <xsl:template match="Hdr" mode="Document">
    <h3>Header</h3>
    <dl>
      <xsl:apply-templates select="InitgPty|RcptPty|Tracblt" mode="x"/>
    </dl>
  </xsl:template>
  <!-- -->
  <xsl:template match="Hdr/InitgPty" mode="x">
    <dt>Initiated by:</dt>
    <dd>
      <dl>
        <xsl:apply-templates/>
      </dl>
    </dd>
  </xsl:template>
  <xsl:template match="Hdr/RcptPty" mode="x">
    <dt>Recipient:</dt>
    <dd>
      <dl>
        <xsl:apply-templates/>
      </dl>
    </dd>
  </xsl:template>
  <xsl:template match="Hdr/Tracblt" mode="x">
    <dt>Tracebility (<xsl:value-of select="position()"/>):</dt>
    <dd>
      <dl>
        <xsl:apply-templates/>
      </dl>
    </dd>
  </xsl:template>
  <xsl:template match="Id">
    <dt>Id</dt>
    <dd>
      <xsl:value-of select="."/>
    </dd>
  </xsl:template>
  <!-- -->
  <xsl:template match="*[/Id]" name="GenericIdentificationAny">
    <xsl:value-of select="."/>
  </xsl:template>
  <!-- -->
  <xsl:template name="PartTypeAnyCode">
    <xsl:param name="code"/>
    <xsl:choose>
      <xsl:when test="$code = 'OPOI'">PoI</xsl:when>
      <xsl:when test="$code = 'MERC'">Merchant</xsl:when>
      <xsl:when test="$code = 'ACCP'">Acceptor</xsl:when>
      <xsl:when test="$code = 'ITAG'">Intermediary agent</xsl:when>
      <xsl:when test="$code = 'ACQR'">Acquirer</xsl:when>
      <xsl:when test="$code = 'CISS'">Card issuer</xsl:when>
      <xsl:when test="$code = 'TAXH'">TAXH</xsl:when>
      <xsl:when test="$code = 'DLIS'">DLIS</xsl:when>
      <xsl:when test="$code = 'ICCA'">ICCA</xsl:when>
      <xsl:when test="$code = 'PCPT'">PCPT</xsl:when>
      <xsl:when test="$code = 'TMGT'">TMGT</xsl:when>
      <xsl:when test="$code = 'SALE'">SALE</xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- -->
  <xsl:template match="Tp">
    <dt>Type</dt>
    <dd>
      <xsl:call-template name="PartTypeAnyCode">
        <xsl:with-param name="code" select="."/>
      </xsl:call-template>
    </dd>
  </xsl:template>
  <!-- -->
  <xsl:template match="Issr">
    <dt>Assigned by</dt>
    <dd>
      <xsl:call-template name="PartTypeAnyCode">
        <xsl:with-param name="code" select="."/>
      </xsl:call-template>
    </dd>
  </xsl:template>
  <!-- -->
  <xsl:template match="Ctry">
    <dt>Country</dt>
    <dd>
      <xsl:value-of select="."/>
    </dd>
  </xsl:template>
  <!-- -->
  <xsl:template match="ShrtNm">
    <dt>Short name</dt>
    <dd>
      <xsl:value-of select="."/>
    </dd>
  </xsl:template>


  <!-- START Security Trailer -->
  <xsl:template match="SctyTrlr" name="ContentInformationType16" mode="Document">
    <h3>Security information</h3>
    <xsl:apply-templates mode="SecurityTrailer"/>
  </xsl:template>

  <!-- -->

  <xsl:template match="AuthntcdData" name="AuthenticatedData5">
    <xsl:apply-templates mode="SecurityTrailer"/>
  </xsl:template>

  <!-- -->

  <xsl:template match="Vrsn" mode="SecurityTrailer">
    v.<xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="AuthntcdData/Rcpt" mode="SecurityTrailer">
    <xsl:apply-templates mode="SecurityTrailer"/>
  </xsl:template>

  <xsl:template match="MACAlgo" mode="SecurityTrailer">
    <dl>
      <dt>Algorithm</dt>
      <dd><xsl:value-of select="Algo"/></dd>
      <dt>Initialisation vector</dt>
      <dd><xsl:value-of select="Param/InitlstnVctr"/></dd>
      <dt>Byte padding</dt>
      <dd><xsl:value-of select="Param/BPddg"/></dd>
    </dl>
  </xsl:template>

  <xsl:template match="NcpsltdCntt" mode="SecurityTrailer">
    <xsl:apply-templates mode="SecurityTrailer"/>
  </xsl:template>

  <xsl:template match="MAC" mode="SecurityTrailer">
    <span class="right">
      <abbr title="Message Authentication Code">MAC</abbr>
      <xsl:text>: </xsl:text>
      <code>
        <xsl:value-of select="."/>
      </code>
    </span>
  </xsl:template>

  <xsl:template match="AuthntcdData/Rcpt/KEK" mode="SecurityTrailer">
    <p>
      <xsl:text>Signed with: </xsl:text>
      <xsl:value-of select="KEKId/KeyId"/>
      <xsl:text> v.</xsl:text>
      <xsl:value-of select="KEKId/KeyVrsn"/>
      <xsl:text> </xsl:text>
      <code>[<xsl:value-of select="KEKId/DerivtnId"/>]</code>
    </p>
  </xsl:template>

  <xsl:template match="AuthntcdData/Rcpt/KeyTrnsprt" mode="SecurityTrailer">
    <xsl:message terminate="yes">Not implemented</xsl:message>
  </xsl:template>

  <xsl:template match="AuthntcdData/Rcpt/KeyIdr" mode="SecurityTrailer">
    <xsl:message terminate="yes">Not implemented</xsl:message>
  </xsl:template>

  <xsl:template match="KEK/KEKId" mode="SecurityTrailer">
    <dl>
      <xsl:apply-templates/>
    </dl>
  </xsl:template>

  <!-- -->

  <xsl:template match="CnttTp" mode="SecurityTrailer">
    <abbr>
      <xsl:attribute name="title">
        <xsl:choose>
          <xsl:when test=". = 'DATA'">Generic, non-cryptographic, or unqualified data content</xsl:when>
          <xsl:when test=". = 'SIGN'">Digital signature</xsl:when>
          <xsl:when test=". = 'EVLP'">Encrypted data, with encryption key</xsl:when>
          <xsl:when test=". = 'DGST'">Message digest</xsl:when>
          <xsl:when test=". = 'AUTH'">MAC with encryption key</xsl:when>
        </xsl:choose>
      </xsl:attribute>
      <xsl:value-of select="."/>
    </abbr>
    <xsl:text>: </xsl:text>
  </xsl:template>
  <!-- END Security Trailer -->

  <xsl:template match="Hdr/MsgFctn" mode="y">
    <abbr>
      <xsl:attribute name="title">
        <xsl:choose>
          <xsl:when test=". = 'AUTQ'">Non-financial authorisation request</xsl:when>
          <xsl:when test=". = 'AUTP'">Non-financial authorisation response</xsl:when>
          <xsl:when test=". = 'CCAV'">Cancellation advice</xsl:when>
          <xsl:when test=". = 'CCAK'">Cancellation acknowledge</xsl:when>
          <xsl:when test=". = 'CCAQ'">Cancellation request</xsl:when>
          <xsl:when test=". = 'CCAP'">Cancellation response</xsl:when>
          <xsl:when test=". = 'CMPV'">Completion advice</xsl:when>
          <xsl:when test=". = 'CMPK'">Completion acknowledge</xsl:when>
          <xsl:when test=". = 'DCAV'">Currency conversion advice</xsl:when>
          <xsl:when test=". = 'DCRR'">Currency conversion acknowledge</xsl:when>
          <xsl:when test=". = 'DCCQ'">Currency conversion request</xsl:when>
          <xsl:when test=". = 'DCCP'">Currency conversion response</xsl:when>
          <xsl:when test=". = 'DGNP'">Diagnostic request</xsl:when>
          <xsl:when test=". = 'DGNQ'">Diagnostic response</xsl:when>
          <xsl:when test=". = 'FAUQ'">Financial authorisation request</xsl:when>
          <xsl:when test=". = 'FAUP'">Financial authorisation response</xsl:when>
          <xsl:when test=". = 'FCMV'">Financial completion advice</xsl:when>
          <xsl:when test=". = 'FCMK'">Financial completion acknowledge</xsl:when>
          <xsl:when test=". = 'FRVA'">Financial reversal advice</xsl:when>
          <xsl:when test=". = 'FRVR'">Financial reversal acknowledge</xsl:when>
          <xsl:when test=". = 'RCLQ'">Reconciliation request</xsl:when>
          <xsl:when test=". = 'RCLP'">Reconciliation response</xsl:when>
          <xsl:when test=". = 'RRVA'">Non-financial reversal advice</xsl:when>
          <xsl:when test=". = 'RRVR'">Non-financial reversal acknowledge</xsl:when>
          <xsl:when test=". = 'CDDQ'">Card Direct Debit advice</xsl:when>
          <xsl:when test=". = 'CDDK'">Card Direct Debit acknowledge</xsl:when>
          <xsl:when test=". = 'CDDR'">Card Direct Debit request</xsl:when>
          <xsl:when test=". = 'CDDP'">Card Direct Debit response</xsl:when>
        </xsl:choose>
      </xsl:attribute>
    <xsl:value-of select="."/>
  </abbr>
  </xsl:template>
</xsl:stylesheet>
