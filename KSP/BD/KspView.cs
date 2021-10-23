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
        /// ��������� �������� � �������� ���� ����� � ������������.
        /// </summary>
        [Column(TypeName = "date")]
        public DateTime? CommissioningDate { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ��������� �����.
        /// </summary>
        [StringLength(100)]
        public string FactoryNumber { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ������������ ����� ���������.
        /// </summary>
        [StringLength(300)]
        public string Name_InstallationLocation { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ����������� �����.
        /// </summary>
        [StringLength(100)]
        public string InventoryNumber { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ���� �������.
        /// </summary>
        [Column(TypeName = "date")]
        public DateTime? IssueDate { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ����� � ����������.
        /// </summary>
        [StringLength(50)]
        public string RegistrationNumber { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ��������������� �������������� ������ ��.
        /// </summary>
        [StringLength(300)]
        public string MiGroup_Characteristic { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ��� ������ ��.
        /// </summary>
        [Column(Order = 1)]
        [StringLength(10)]
        public string MiGroup_Code { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ������������ ������ ��.
        /// </summary>
        [Column(Order = 2)]
        [StringLength(200)]
        public string MiGroup_Name { get; set; }
        /// <summary>
        /// ��������� �������� � �������� �������� ������ ��.
        /// </summary>
        [Key] [Column(Order = 3)]
        [StringLength(300)]
        public string MiGroup_Range { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ��� ������� ���������.
        /// </summary>
        [StringLength(10)]
        public string MeasurementFieldCode { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ������������ ������� ���������.
        /// </summary>
        [StringLength(200)]
        public string MeasurementFieldName { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ����� ���� ������������� � �������/����������.
        /// </summary>
        [Column(TypeName = "date")]
        public DateTime? CertificateDate { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ����� ������������� � �������/����������.
        /// </summary>
        [StringLength(30)]
        public string CertificateNumber { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ����� ���������������� ���������� �������.
        /// </summary>
        [StringLength(32)]
        public string FirsVerificationNumber { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ����� �� � �������� ������� �� ������� ��� ���.
        /// </summary>
        [StringLength(32)]
        public string MiVerificationNumber { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ������������ ������� �� ������� ��� ���.
        /// </summary>
        [StringLength(1200)]
        public string VerificationToolName { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ���� �������� �����������.
        /// </summary>
        [Column(TypeName = "date")]
        public DateTime? ValidityCertificateDate { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ����� �������.
        /// </summary>
        [StringLength(32)]
        public string VerificationNumber { get; set; }
        /// <summary>
        /// ��������� �������� � �������� �������� �������.
        /// </summary>
        [StringLength(300)]
        public string VerificationTool_Range { get; set; }
        /// <summary>
        /// ��������� �������� � �������� �������������� �������.
        /// </summary>
        [StringLength(200)]
        public string VerificationTool_Characteristic { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ������ �������.
        /// </summary>
        [StringLength(100)]
        public string VerificationTool_Discharge { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ����������� ���� ��.
        /// </summary>
        [Column(Order = 4)]
        [StringLength(200)]
        public string Designation { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ������������ ���� ��.
        /// </summary>
        [Column(Order = 5)]
        [StringLength(300)]
        public string TypeSiName { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ��������������-�������� ����� ������������.
        /// </summary>
        [StringLength(10)]
        public string Manufacturer_LegalForm { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ������������ ������������.
        /// </summary>
        [StringLength(300)]
        public string Manufacturer_Name { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ������ ������������.
        /// </summary>
        [StringLength(100)]
        public string Manufacturer_Country { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ������ ������������.
        /// </summary>
        [StringLength(300)]
        public string Manufacturer_Region { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ������������ ���������.
        /// </summary>
        [StringLength(300)]
        public string Owner_Name { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ��������������-�������� ����� ���������.
        /// </summary>
        [StringLength(10)]
        public string Owner_LegalForm { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ������ ���������.
        /// </summary>
        [StringLength(100)]
        public string Owner_Country { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ������ ���������.
        /// </summary>
        [StringLength(200)]
        public string Owner_Region { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ��������(�) ��� ������ ��.
        /// </summary>
        public string MiGroupDocument { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ����� ��������������� ��������(�).
        /// </summary>
        public string TitleDocument { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ����� ������ � ��� ��� � �������.
        /// </summary>
        [StringLength(500)]
        public string LINKNNFIF { get; set; }
        /// <summary>
        /// ��������� �������� � �������� ��� ������� ���������.
        /// </summary>
        public int? CODE { get; set; }
    }
}
