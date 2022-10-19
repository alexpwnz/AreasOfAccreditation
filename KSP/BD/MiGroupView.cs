using System.ComponentModel;

namespace KSP.BD
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("MiGroupView")]
    public partial class MiGroupView
    {
        [Key]
        [Browsable(false)]
        [Column(Order = 0)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public long Uid { get; set; }

        [Browsable(false)]
        public int Id { get; set; }
        
        [Column(Order = 1)]
        [StringLength(1000)]
        public string Characteristic { get; set; }
        
        [Column(Order = 2)]
        [StringLength(1000)]
        public string Name { get; set; }
        
        [Column(Order = 3)]
        [StringLength(1000)]
        public string Range { get; set; }

        [StringLength(200)]
        public string MeasurementField_Name { get; set; }

        public int? CODE { get; set; }
    }
}
