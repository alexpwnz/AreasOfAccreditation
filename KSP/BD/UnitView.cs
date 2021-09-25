using System.ComponentModel;

namespace KSP.BD
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("UnitView")]
    public partial class UnitView
    {
        [Key]
        [Browsable(false)]
        [Column(Order = 0)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int Id { get; set; }
        [Display(Name = "Наименование эталона")]
        [StringLength(1200)]
        public string Name { get; set; }

        [StringLength(32)]
        [Display(Name = "№ эталона в ФИФ ОЕИ")]
        public string VerificationNumber { get; set; }

        [StringLength(32)]
        [Display(Name = "№ ГПЭ")]
        public string FirsVerificationNumber { get; set; }

        [StringLength(32)]
        [Display(Name = "№ по реестру ФИФ ОЕИ")]
        public string MiVerificationNumber { get; set; }
        [Display(Name = "Номер свидетельства")]
        [StringLength(30)]
        public string CertificateNumber { get; set; }
        [Display(Name = "Дата свидетельства")]
        [Column(TypeName = "date")]
        public DateTime? CertificateDate { get; set; }
        [Display(Name = "Дата действия свидетельства")]
        [Column(TypeName = "date")]
        public DateTime? ValidityCertificateDate { get; set; }

        [StringLength(300)]
        [Display(Name = "Диапазон")]
        public string VerificationTool_Range { get; set; }

        [StringLength(200)]
        [Display(Name = "Характеристика")]
        public string VerificationTool_Characteristic { get; set; }

        [StringLength(100)]
        [Display(Name = "Класс")]
        public string VerificationTool_Discharge { get; set; }

        [StringLength(100)]
        [Display(Name = "Заводской №")]
        public string FactoryNumber { get; set; }

        [StringLength(100)]
        [Display(Name = "Инвентарный №")]
        public string InventoryNumber { get; set; }

        [StringLength(50)]
        [Display(Name = "№ Госреестра СИ")]
        public string RegistrationNumber { get; set; }

        [Column(TypeName = "date")]
        [Display(Name = "Дата выпуска")]
        public DateTime? IssueDate { get; set; }

        [Column(TypeName = "date")]
        [Display(Name = "Дата ввода в эксплуатацию")]
        public DateTime? CommissioningDate { get; set; }

        [StringLength(300)]
        [Display(Name = "Место установки")]
        public string InstallationLocation_Name { get; set; }

        [StringLength(300)]
        [Display(Name = "Наименование орг. изготовителя")]
        public string Manufacturer_Name { get; set; }

        [StringLength(300)]
        [Display(Name = "Наименование орг. владельца")]
        public string Ownership_Name { get; set; }

        [Key]
        [Column(Order = 1)]
        [StringLength(300)]
        [Display(Name = "Тип СИ")]
        public string TypeSi_Name { get; set; }
        [Key]
        [Column(Order = 2)]
        [StringLength(200)]
        [Display(Name = "Обозначение типа")]
        public string TypeSi_Designation { get; set; }
        [StringLength(500)]
        public string LINKNNFIF { get; set; }
    }
}
