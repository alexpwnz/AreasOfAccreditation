using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace KSP.BD
{
    [Table("DocumentView")]
    public partial class DocumentView
    {
        [Display(Name = "Тип документа")]
        [StringLength(10)]
        public string DocumentType_Name { get; set; }
        [Display(Name = "Дата документа")]
        [Column(TypeName = "date")]
        public DateTime? Date { get; set; }
        [Display(Name = "Наименование документа")]
        [StringLength(400)]
        public string Name { get; set; }

        [Display(Name = "Номер")]
        [StringLength(100)]
        public string Number { get; set; }
        [Browsable(false)]
        public int? FK_DocumentType { get; set; }
        [Browsable(false)]
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int Id { get; set; }
    }
}
