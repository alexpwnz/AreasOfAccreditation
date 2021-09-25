using System.ComponentModel;

namespace KSP.BD
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("MeasurementField")]
    public partial class MeasurementField
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public MeasurementField()
        {
            MiGroups = new HashSet<MiGroup>();
        }
        [Browsable(false)]
        public int Id { get; set; }

        [StringLength(200)]
        [Display(Name = "Наименование")]
        public string Name { get; set; }

        [StringLength(10)]
        [Display(Name = "Код")]
        public string Code { get; set; }
        [Browsable(false)]
        public int? IdExt { get; set; }
        [Browsable(false)]
        public Guid? GuidExt { get; set; }
        [Browsable(false)]
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<MiGroup> MiGroups { get; set; }
    }
}
