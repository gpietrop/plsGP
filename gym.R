# load packages
library(cSEM)

# Model specification is done in lavaan syntax
# Note: not all functionalities known from lavaan are covered in cSEM, e.g., 
# starting values, parameter labeling, constraints
# 
# =~ define latent variable/common factor
# <~ define emergent variable/composite
# ~ define structural model 
# ~~ allow for correlations among measurement errors in reflective measurement models


model_Bergami="
# Measurement models
OrgPres <~ cei1 + cei2 + cei3 + cei4 + cei5 + cei6 + cei7 + cei8 
OrgIden =~ ma1 + ma2 + ma3 + ma4 + ma5 + ma6
AffJoy =~ orgcmt1 + orgcmt2 + orgcmt3 + orgcmt7
AffLove  =~ orgcmt5 + orgcmt5 + orgcmt8
Gender<~ gender

# Structural model 
OrgIden ~ OrgPres 
AffLove ~ OrgPres+OrgIden+Gender
AffJoy  ~ OrgPres+OrgIden+Gender"

outBergamiboot <- csem(.data = BergamiBagozzi2000,.model = model_Bergami,
                       .disattenuate = T,
                       .PLS_weight_scheme_inner = 'factorial',
                       .tolerance = 1e-5,
                       .resample_method = 'bootstrap',.R = 499)

verify(outBergamiboot)

summarize(outBergamiboot)

assess(outBergamiboot)

calculateModelSelectionCriteria(outBergamiboot)
