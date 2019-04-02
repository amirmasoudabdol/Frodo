CREATE TABLE sim (
	simid INTEGER NULL,
	pid INTEGER NULL,
	tnobs INTEGER NULL,
	tyi REAL NULL,
	tvi REAL NULL,
	inx INTEGER NULL,
	nobs INTEGER NULL,
	yi REAL NULL,
	sei REAL NULL,
	statistic REAL NULL,
	pvalue REAL NULL,
	CohensD REAL NULL,
	HedgesG REAL NULL,
	PearsonR REAL NULL,
	side INTEGER NULL
);

CREATE TABLE meta (
	simid INTEGER NULL,
	meta_b REAL NULL,
	meta_se REAL NULL,
	meta_zval REAL NULL,
	meta_pval REAL NULL,
	meta_ci_lb REAL NULL,
	meta_ci_ub REAL NULL,
	meta_tau2 REAL NULL,
	meta_se_tau2 REAL NULL,
	meta_QE REAL NULL,
	meta_QEp REAL NULL,
	triml_k0 REAL NULL,
	triml_b REAL NULL,
	triml_se REAL NULL,
	triml_zval REAL NULL,
	triml_pval REAL NULL,
	triml_ci_lb REAL NULL,
	triml_ci_ub REAL NULL,
	trimr_k0 REAL NULL,
	trimr_b REAL NULL,
	trimr_se REAL NULL,
	trimr_zval REAL NULL,
	trimr_pval REAL NULL,
	trimr_ci_lb REAL NULL,
	trimr_ci_ub REAL NULL,
	rank_tau REAL NULL,
	rank_pval REAL NULL,
	egg_zval REAL NULL,
	egg_pval REAL NULL,
	egg_b REAL NULL,
	reg_pval REAL NULL,
	reg_r_squared REAL NULL,
	d REAL NULL,
	b REAL NULL,
	e REAL NULL,
	k REAL NULL,
	ish REAL NULL,
	h REAL NULL
);

PRAGMA main.page_size = 4096;
PRAGMA main.cache_size=10000;
PRAGMA main.locking_mode=EXCLUSIVE;
PRAGMA main.synchronous=NORMAL;
PRAGMA main.journal_mode=WAL;
PRAGMA main.cache_size=5000;