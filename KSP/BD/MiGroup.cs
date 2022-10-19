using System.ComponentModel;

namespace KSP.BD
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("MiGroup")]
    public partial class MiGroup
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public MiGroup()
        {
            KSPs = new HashSet<KSP>();
            MiGroupDocuments = new HashSet<MiGroupDocument>();
        }
        [Browsable(false)]
        public int Id { get; set; }
        [Display(Name = "Код")]
        [Required]
        [StringLength(10)]
        public string Code { get; set; }
        [Display(Name = "Наименование")]
        [Required]
        [StringLength(1000)]
        public string Name { get; set; }

        [Display(Name = "Характеристика")]
        [Required]
        [StringLength(1000)]
        public string Characteristic { get; set; }
        [Display(Name = "Диапазон")]
        [Required]
        [StringLength(1000)]
        public string Range { get; set; }
        [Browsable(false)]
        public int FK_MeasurementField { get; set; }
        [Browsable(false)]
        public int? IdExt { get; set; }
        [Browsable(false)]
        public Guid? GuidExt { get; set; }
        [Browsable(false)]
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<KSP> KSPs { get; set; }
        [Browsable(false)]
        public virtual MeasurementField MeasurementField { get; set; }
        [Browsable(false)]
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<MiGroupDocument> MiGroupDocuments { get; set; }
    }
}
