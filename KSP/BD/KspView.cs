namespace KSP.BD
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("KspView")]
    public partial class KspView
    {
        [Column(TypeName = "date")]
        public DateTime? CommissioningDate { get; set; }

        [StringLength(100)]
        public string FactoryNumber { get; set; }

        [StringLength(300)]
        public string Name_InstallationLocation { get; set; }

        [StringLength(100)]
        public string InventoryNumber { get; set; }

        [Column(TypeName = "date")]
        public DateTime? IssueDate { get; set; }

        [StringLength(50)]
        public string RegistrationNumber { get; set; }

        [Key]
        [Column(Order = 0)]
        [StringLength(300)]
        public string MiGroup_Characteristic { get; set; }

        [Key]
        [Column(Order = 1)]
        [StringLength(10)]
        public string MiGroup_Code { get; set; }

        [Key]
        [Column(Order = 2)]
        [StringLength(200)]
        public string MiGroup_Name { get; set; }

        [Key]
        [Column(Order = 3)]
        [StringLength(300)]
        public string MiGroup_Range { get; set; }

        [StringLength(10)]
        public string MeasurementFieldCode { get; set; }

        [StringLength(200)]
        public string MeasurementFieldName { get; set; }

        [Column(TypeName = "date")]
        public DateTime? CertificateDate { get; set; }

        [StringLength(30)]
        public string CertificateNumber { get; set; }

        [StringLength(32)]
        public string FirsVerificationNumber { get; set; }

        [StringLength(32)]
        public string MiVerificationNumber { get; set; }

        [StringLength(1200)]
        public string VerificationToolName { get; set; }

        [Column(TypeName = "date")]
        public DateTime? ValidityCertificateDate { get; set; }

        [StringLength(32)]
        public string VerificationNumber { get; set; }

        [StringLength(300)]
        public string VerificationTool_Range { get; set; }

        [StringLength(200)]
        public string VerificationTool_Characteristic { get; set; }

        [StringLength(100)]
        public string VerificationTool_Discharge { get; set; }

        [Key]
        [Column(Order = 4)]
        [StringLength(200)]
        public string Designation { get; set; }

        [Key]
        [Column(Order = 5)]
        [StringLength(300)]
        public string TypeSiName { get; set; }

        [StringLength(10)]
        public string Manufacturer_LegalForm { get; set; }

        [StringLength(300)]
        public string Manufacturer_Name { get; set; }

        [StringLength(100)]
        public string Manufacturer_Country { get; set; }

        [StringLength(300)]
        public string Manufacturer_Region { get; set; }

        [StringLength(300)]
        public string Owner_Name { get; set; }

        [StringLength(10)]
        public string Owner_LegalForm { get; set; }

        [StringLength(100)]
        public string Owner_Country { get; set; }

        [StringLength(200)]
        public string Owner_Region { get; set; }

        public string MiGroupDocument { get; set; }
        public string TitleDocument { get; set; }
        [StringLength(500)]
        public string LINKNNFIF { get; set; }

        public int? CODE { get; set; }
    }
}
