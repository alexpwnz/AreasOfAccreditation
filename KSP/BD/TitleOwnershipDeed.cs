using System.ComponentModel;

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
        [Browsable(false)]
        public int? IdExt { get; set; }
        [Browsable(false)]
        public Guid? GuidExt { get; set; }
        [Browsable(false)]
        public virtual Document Document { get; set; }
        [Browsable(false)]
        public virtual MeasuringInstrument MeasuringInstrument { get; set; }
    }
}
