if (getRversion() >= "2.15.1") {
  utils::globalVariables(c(
    # "ptdob",
    # "de_eval_date",
    # "verbal",
    # "nonverbal",
    # "iq",
    # "min_age",
    # "max_age",
    # "ae",
    # "crf_data",
    # "crf_data_exclude_phi",
    # "coenroll_exclude_phi",
    # "dd_field_name",
    # "dd_revision_field_value",
    # "subject_label",
    # "site_label",
    # "Site",
    # "items",
    # "edc",
    # "inner_join",
    # ".",
    # "latest",
    # "de_race",
    # "abcds",
    # "trcds",
    # "full_join",
    # "data_dictionary",
    # "control"
  ))
}


.all_reports <- c(
  "enrollment_by_cycle",
  "demographics",
  "cognition_task_counts",
  "ntgedsd_counts",
  "imaging_scan_counts",
  "imaging_scan_counts_controls",
  "mri_sequence_counts",
  "mri_sequence_counts_controls",
  "imaging_scan_counts_by_site",
  "consensus_primary_by_cycle",
  "healthhistory",
  "healthhistory_by_sex",
  "apoe",
  "karyotype",
  "karyotype_by_site",
  "blood_draw_counts",
  "blood_draw_counts_controls",
  "csf_counts",
  "csf_counts_controls",
  "omics"
)


.cognition_tasks <- c(
  "blockhaxby",
  "blockwisc",
  "catdog",
  "dsmse",
  "moca",
  "pegboard",
  "ppvt5",
  "radd",
  "recall",
  "cogrecall",
  "tbatgs",
  "verbal",
  "vmi"
)


.mri_sequence_key <- list(
  id = 1:7,
  abbreviation = c(
    "T1 MPRAGE/ISSPGR",
    "3D FLAIR",
    "T2*/SWI",
    "DTI",
    "ASL",
    "T2 FSE",
    "rs-fMRI"
  ),
  description = c(
    "T1 MPRAGE/ISSPGR Sagittal 3D Accelerated MPRAGE/IRSPGR (ADNI3 Sequence)",
    "3D FLAIR Sagittal 3D FLAIR (ADNI3 Sequence)",
    "T2*/SWI Axial 3D ME T2 GRE \u2013 Axial 3D T2 GRE \u2013 Axial T2 Star/GRE",
    "DTI Axial DTI PA (multiband if applicable) Axial DTI AP (multiband if applicable)",
    "ASL Axial 3D pCASL or Axial 3D PASL",
    "T2 FSE Sagittal 3D T2 Weighted Sequence",
    "rs-fMRI Axial fcMRI (multiband if applicable)"
  )
)

.imaging_key <- list(
  atri_scan_names = c("amymeta", "taumeta", "mrimeta", "fdgmeta"),
  loni_scan_names = c("amy", "tau", "mri", "fdg"),
  scan_labels = c(
    "Amyloid PET Scan",
    "Tau PET Scan",
    "MRI Imaging",
    "FDG PET Scan"
  )
)


.disclosure_key <- list(
  abcds = list(
    demographics = c("de_eval_date", "de_gender"),
    dsmse = c("dsto2", "dsla2", "colshbx", "dsme1", "dsvs1"),
    recall = c("frssa", "frssb", "crssa", "crssb"),
    ntgedsd = c(
      "adltot",
      "ntlctot",
      "ntswtot",
      "ntambtot",
      "ntmemtot",
      "ntbehtot",
      "ntsrptot",
      "ntootot"
    ),
    exam = c("ht", "htu", "wt", "wtu", "bpsys", "bpdia")
  ),
  trcds = list(
    registry = c("examdate"),
    dsmse = c("dsto2", "dsla2", "colshbx", "dsme1", "dsvs1"),
    recall = c("frssa", "frssb", "crssa", "crssb"),
    ntgedsd = c(
      "adltot",
      "ntlctot",
      "ntswtot",
      "ntambtot",
      "ntmemtot",
      "ntbehtot",
      "ntsrptot",
      "ntootot"
    ),
    exam = c(
      "vsheight",
      "vshtunit",
      "vsweight",
      "vswtunit",
      "vsbpsys",
      "vsbpdia"
    )
  )
)
