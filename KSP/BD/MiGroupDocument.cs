using System.ComponentModel;

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
        [Browsable(false)]
        public int? IdExt { get; set; }
        [Browsable(false)]
        public Guid? GuidExt { get; set; }
        [Browsable(false)]
        public virtual Document Document { get; set; }
        [Browsable(false)]
        public virtual MiGroup MiGroup { get; set; }
    }
}
