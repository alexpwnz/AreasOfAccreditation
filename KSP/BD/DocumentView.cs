using System.ComponentModel;

namespace KSP.BD
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("DocumentView")]
    public partial class DocumentView
    {
        [Key]
        [Browsable(false)]
        [Column(Order = 0)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public long Uid { get; set; }
        [Display(Name = "��� ���������")]
        [StringLength(10)]
        public string DocumentType_Name { get; set; }
        [Display(Name = "���� ���������")]
        [Column(TypeName = "date")]
        public DateTime? Date { get; set; }
        [Display(Name = "������������ ���������")]
        [StringLength(400)]
        public string Name { get; set; }
        [Display(Name = "�����")]
        [StringLength(100)]
        public string Number { get; set; }
        [Browsable(false)]
        public int? FK_DocumentType { get; set; }
        [Browsable(false)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int Id { get; set; }
    }
}
