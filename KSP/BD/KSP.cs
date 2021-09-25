namespace KSP.BD
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("KSP")]
    public partial class KSP
    {
        public int Id { get; set; }

        public int FK_MeasuringInstrument { get; set; }

        public int FK_MiGroup { get; set; }

        public int? IdExt { get; set; }

        public Guid? GuidExt { get; set; }

        public virtual MeasuringInstrument MeasuringInstrument { get; set; }

        public virtual MiGroup MiGroup { get; set; }
    }
}
