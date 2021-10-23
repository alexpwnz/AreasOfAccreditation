namespace KSP.BD
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("MiGroupDocument")]
    public partial class MiGroupDocument
    {
        public int Id { get; set; }

        public int FK_Document { get; set; }

        public int FK_MiGroup { get; set; }

        public int? IdExt { get; set; }

        public Guid? GuidExt { get; set; }

        public virtual Document Document { get; set; }

        public virtual MiGroup MiGroup { get; set; }
    }
}
