mysqldump \
--ignore-table=ocadmin_dbo.accesslogs \
--ignore-table=openclinic_dbo.concepts \
--ignore-table=openclinic_dbo.errors \
--ignore-table=openclinic_dbo.items \
--ignore-table=openclinic_dbo.itemshistory \
--ignore-table=openclinic_dbo.keywords \
--ignore-table=openclinic_dbo.oc_batchoperations \
--ignore-table=openclinic_dbo.oc_debets \
--ignore-table=openclinic_dbo.oc_debets_history \
--ignore-table=openclinic_dbo.oc_encounters \
--ignore-table=openclinic_dbo.oc_encounters_history \
--ignore-table=openclinic_dbo.oc_insurances \
--ignore-table=openclinic_dbo.oc_insurances_history \
--ignore-table=openclinic_dbo.oc_labels \
--ignore-table=openclinic_dbo.oc_pacs \
--ignore-table=openclinic_dbo.oc_patientcredits \
--ignore-table=openclinic_dbo.oc_patientinvoices \
--ignore-table=openclinic_dbo.oc_patientinvoices_history \
--ignore-table=openclinic_dbo.oc_productstocks_history \
--ignore-table=openclinic_dbo.oc_productstockoperations \
--ignore-table=openclinic_dbo.oc_wicket_credits \
--ignore-table=openclinic_dbo.requestedlabanalyses \
--ignore-table=openclinic_dbo.transactions \
--ignore-table=openclinic_dbo.transactionshistory \
--databases ocadmin_dbo openclinic_dbo ocstats_dbo > oc.dmp