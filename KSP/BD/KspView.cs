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
        [Key]
        [Column(Order = 0)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public long Uid { get; set; }
        /// <summary>
        /// Позволяет получать и задавать дату ввода в эксплуатацию.
        /// </summary>
        [Column(TypeName = "date")]
        public DateTime? CommissioningDate { get; set; }
        /// <summary>
        /// Позволяет получать и задавать заводской номер.
        /// </summary>
        [StringLength(100)]
        public string FactoryNumber { get; set; }
        /// <summary>
        /// Позволяет получать и задавать наименование места установки.
        /// </summary>
        [StringLength(300)]
        public string Name_InstallationLocation { get; set; }
        /// <summary>
        /// Позволяет получать и задавать инвентарный номер.
        /// </summary>
        [StringLength(100)]
        public string InventoryNumber { get; set; }
        /// <summary>
        /// Позволяет получать и задавать дату выпуска.
        /// </summary>
        [Column(TypeName = "date")]
        public DateTime? IssueDate { get; set; }
        /// <summary>
        /// Позволяет получать и задавать номер в госреестре.
        /// </summary>
        [StringLength(50)]
        public string RegistrationNumber { get; set; }
        /// <summary>
        /// Позволяет получать и задавать метрологическую характеристики группы си.
        /// </summary>
        [StringLength(300)]
        public string MiGroup_Characteristic { get; set; }
        /// <summary>
        /// Позволяет получать и задавать код группы СИ.
        /// </summary>
        [Column(Order = 1)]
        [StringLength(10)]
        public string MiGroup_Code { get; set; }
        /// <summary>
        /// Позволяет получать и задавать наименование группы СИ.
        /// </summary>
        [Column(Order = 2)]
        [StringLength(200)]
        public string MiGroup_Name { get; set; }
        /// <summary>
        /// Позволяет получать и задавать диапазон группы СИ.
        /// </summary>
        [Key] [Column(Order = 3)]
        [StringLength(300)]
        public string MiGroup_Range { get; set; }
        /// <summary>
        /// Позволяет получать и задавать код области измерения.
        /// </summary>
        [StringLength(10)]
        public string MeasurementFieldCode { get; set; }
        /// <summary>
        /// Позволяет получать и задавать наименование области измерения.
        /// </summary>
        [StringLength(200)]
        public string MeasurementFieldName { get; set; }
        /// <summary>
        /// Позволяет получать и задавать номер дату свидетельства о поверке/калибровки.
        /// </summary>
        [Column(TypeName = "date")]
        public DateTime? CertificateDate { get; set; }
        /// <summary>
        /// Позволяет получать и задавать номер свидетельства о поверке/калибровки.
        /// </summary>
        [StringLength(30)]
        public string CertificateNumber { get; set; }
        /// <summary>
        /// Позволяет получать и задавать номер государственного первичного эталона.
        /// </summary>
        [StringLength(32)]
        public string FirsVerificationNumber { get; set; }
        /// <summary>
        /// Позволяет получать и задавать номер СИ в качестве эталона по реестру ФИФ ОЕИ.
        /// </summary>
        [StringLength(32)]
        public string MiVerificationNumber { get; set; }
        /// <summary>
        /// Позволяет получать и задавать наименование эталона по реестру ФИФ ОЕИ.
        /// </summary>
        [StringLength(1200)]
        public string VerificationToolName { get; set; }
        /// <summary>
        /// Позволяет получать и задавать дату действия сертификата.
        /// </summary>
        [Column(TypeName = "date")]
        public DateTime? ValidityCertificateDate { get; set; }
        /// <summary>
        /// Позволяет получать и задавать номер эталона.
        /// </summary>
        [StringLength(32)]
        public string VerificationNumber { get; set; }
        /// <summary>
        /// Позволяет получать и задавать диапазон эталона.
        /// </summary>
        [StringLength(300)]
        public string VerificationTool_Range { get; set; }
        /// <summary>
        /// Позволяет получать и задавать характеристику эталона.
        /// </summary>
        [StringLength(200)]
        public string VerificationTool_Characteristic { get; set; }
        /// <summary>
        /// Позволяет получать и задавать разряд эталона.
        /// </summary>
        [StringLength(100)]
        public string VerificationTool_Discharge { get; set; }
        /// <summary>
        /// Позволяет получать и задавать обозначение типа СИ.
        /// </summary>
        [Column(Order = 4)]
        [StringLength(200)]
        public string Designation { get; set; }
        /// <summary>
        /// Позволяет получать и задавать наименование типа СИ.
        /// </summary>
        [Column(Order = 5)]
        [StringLength(300)]
        public string TypeSiName { get; set; }
        /// <summary>
        /// Позволяет получать и задавать организационно-правовую форму изготовителя.
        /// </summary>
        [StringLength(10)]
        public string Manufacturer_LegalForm { get; set; }
        /// <summary>
        /// Позволяет получать и задавать наименование изготовителя.
        /// </summary>
        [StringLength(300)]
        public string Manufacturer_Name { get; set; }
        /// <summary>
        /// Позволяет получать и задавать страну изготовителя.
        /// </summary>
        [StringLength(100)]
        public string Manufacturer_Country { get; set; }
        /// <summary>
        /// Позволяет получать и задавать регион изготовителя.
        /// </summary>
        [StringLength(300)]
        public string Manufacturer_Region { get; set; }
        /// <summary>
        /// Позволяет получать и задавать наименование владельца.
        /// </summary>
        [StringLength(300)]
        public string Owner_Name { get; set; }
        /// <summary>
        /// Позволяет получать и задавать организационно-правовую форму владельца.
        /// </summary>
        [StringLength(10)]
        public string Owner_LegalForm { get; set; }
        /// <summary>
        /// Позволяет получать и задавать страну владельца.
        /// </summary>
        [StringLength(100)]
        public string Owner_Country { get; set; }
        /// <summary>
        /// Позволяет получать и задавать регион владельца.
        /// </summary>
        [StringLength(200)]
        public string Owner_Region { get; set; }
        /// <summary>
        /// Позволяет получать и задавать документ(ы) для группы СИ.
        /// </summary>
        public string MiGroupDocument { get; set; }
        /// <summary>
        /// Позволяет получать и задавать право устанавливающий документ(ы).
        /// </summary>
        public string TitleDocument { get; set; }
        /// <summary>
        /// Позволяет получать и задавать номер записи в ФИФ ОЕИ о поверке.
        /// </summary>
        [StringLength(500)]
        public string LINKNNFIF { get; set; }
        /// <summary>
        /// Позволяет получать и задавать код области измерения.
        /// </summary>
        public int? CODE { get; set; }
    }
}
