using System.ComponentModel;

namespace KSP.BD
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("VerificationTool")]
    public partial class VerificationTool
    {
        [Browsable(false)]
        public int Id { get; set; }

        [StringLength(1200)]
        [Display(Name = "������������ �������")]
        public string Name { get; set; }

        [StringLength(32)]
        public string VerificationNumber { get; set; }

        [StringLength(32)]
        public string FirsVerificationNumber { get; set; }

        [StringLength(32)]
        public string MiVerificationNumber { get; set; }

        [StringLength(30)]
        [Display(Name = "����� �������������")]
        public string CertificateNumber { get; set; }

        [Column(TypeName = "date")]
        [Display(Name = "���� �������������")]
        public DateTime? CertificateDate { get; set; }

        [Column(TypeName = "date")]
        [Display(Name = "���� �����������")]
        public DateTime? ValidityCertificateDate { get; set; }

        [Browsable(false)]
        public int FK_MeasuringInstrument { get; set; }

        [StringLength(300)]
        [Display(Name = "��������")]
        public string Range { get; set; }

        [StringLength(200)]
        [Display(Name = "��������������")]
        public string Characteristic { get; set; }

        [StringLength(100)]

        [Display(Name = "������")]
        public string Discharge { get; set; }
        [Display(Name = "� ��� ���")]
        [StringLength(500)]
        public string LINKNNFIF { get; set; }
        [Browsable(false)]
        public int? IdExt { get; set; }
        [Browsable(false)]
        public Guid? GuidExt { get; set; }
        [Browsable(false)]
        public virtual MeasuringInstrument MeasuringInstrument { get; set; }
    }
}
