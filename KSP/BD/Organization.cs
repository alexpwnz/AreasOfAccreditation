using System.ComponentModel;

namespace KSP.BD
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("Organization")]
    public partial class Organization
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Organization()
        {
            MeasuringInstruments = new HashSet<MeasuringInstrument>();
            MeasuringInstruments1 = new HashSet<MeasuringInstrument>();
        }
        [Browsable(false)]
        public int Id { get; set; }

        [Required]
        [StringLength(300)]
        [Display(Name = "Наименование")]
        public string Name { get; set; }

        [StringLength(100)]
        [Display(Name = "Страна")]
        public string Country { get; set; }

        [StringLength(200)]
        [Display(Name = "Регион")]
        public string Region { get; set; }

        [StringLength(10)]
        [Display(Name = "Юр. форма")]
        public string LegalForm { get; set; }
        [Browsable(false)]
        public int? IdExt { get; set; }
        [Browsable(false)]
        public Guid? GuidExt { get; set; }
        [Browsable(false)]
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<MeasuringInstrument> MeasuringInstruments { get; set; }
        [Browsable(false)]
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<MeasuringInstrument> MeasuringInstruments1 { get; set; }
    }
}
