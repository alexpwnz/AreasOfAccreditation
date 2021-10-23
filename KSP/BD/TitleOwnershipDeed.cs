namespace KSP.BD
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("TitleOwnershipDeed")]
    public partial class TitleOwnershipDeed
    {
        public int Id { get; set; }

        public int FK_MeasuringInstrument { get; set; }

        public int FK_Document { get; set; }

        public int? IdExt { get; set; }

        public Guid? GuidExt { get; set; }

        public virtual Document Document { get; set; }

        public virtual MeasuringInstrument MeasuringInstrument { get; set; }
    }
}
