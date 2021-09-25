using System.ComponentModel;

namespace KSP.BD
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("TypeSi")]
    public partial class TypeSi
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public TypeSi()
        {
            MeasuringInstruments = new HashSet<MeasuringInstrument>();
        }
        [Browsable(false)]
        public int Id { get; set; }

        [Required]
        [StringLength(300)]
        [Display(Name = "Наименование")]
        public string Name { get; set; }

        [Required]
        [StringLength(200)]
        [Display(Name = "Обозначение")]
        public string Designation { get; set; }
        [Browsable(false)]
        public int? IdExt { get; set; }
        [Browsable(false)]
        public Guid? GuidExt { get; set; }
        [Browsable(false)]
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<MeasuringInstrument> MeasuringInstruments { get; set; }
    }
}
