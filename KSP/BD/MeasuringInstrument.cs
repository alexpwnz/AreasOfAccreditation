namespace KSP.BD
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("MeasuringInstrument")]
    public partial class MeasuringInstrument
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public MeasuringInstrument()
        {
            KSPs = new HashSet<KSP>();
            TitleOwnershipDeeds = new HashSet<TitleOwnershipDeed>();
            VerificationTools = new HashSet<VerificationTool>();
        }

        public int Id { get; set; }

        [StringLength(100)]
        public string FactoryNumber { get; set; }

        [StringLength(100)]
        public string InventoryNumber { get; set; }

        public int FK_TypeSi { get; set; }

        [StringLength(50)]
        public string RegistrationNumber { get; set; }

        public int? FK_Ownership { get; set; }

        public int? FK_InstallationLocation { get; set; }

        [Column(TypeName = "date")]
        public DateTime? IssueDate { get; set; }

        [Column(TypeName = "date")]
        public DateTime? CommissioningDate { get; set; }

        public int? FK_Manufacturer { get; set; }

        public int? IdExt { get; set; }

        public Guid? GuidExt { get; set; }

        public virtual InstallationLocation InstallationLocation { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<KSP> KSPs { get; set; }

        public virtual Organization Organization { get; set; }

        public virtual Organization Organization1 { get; set; }

        public virtual TypeSi TypeSi { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<TitleOwnershipDeed> TitleOwnershipDeeds { get; set; }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<VerificationTool> VerificationTools { get; set; }
    }
}
