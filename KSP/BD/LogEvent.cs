namespace KSP.BD
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("LogEvent")]
    public partial class LogEvent
    {
        public int Id { get; set; }

        public int IdLogTableField { get; set; }

        public int IdObj { get; set; }

        [Required]
        [StringLength(1)]
        public string OperType { get; set; }

        public DateTime OperTime { get; set; }

        [Required]
        [StringLength(100)]
        public string User { get; set; }

        [StringLength(1500)]
        public string OldVal { get; set; }

        [StringLength(1500)]
        public string NewVal { get; set; }
    }
}
