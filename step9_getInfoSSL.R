library(openssl)

# based on http://giantdorks.org/alain/shell-script-to-check-ssl-certificate-info-like-expiration-date-and-subject/

detectSSL <- function(domain) {
  
  try({  
    chain <- download_ssl_cert(domain, 443)
    issuer <- as.list(chain[[1]])$issuer
    
    #print(issuer)
    
    if (grepl("EV", issuer) || grepl("Extended Validation", issuer) )
      return(TRUE)
  })
  
  return(FALSE)
}

# Verify the HTTPS cert
# openssl : detect EV : Extended Validation
# print(detectSSL("data-seo.com"))
# 
# print(detectSSL("mabanque.bnpparibas"))
# 
# print(detectSSL("boursorama.com"))
#                 
# print(detectSSL("boursorama-banque.com"))



