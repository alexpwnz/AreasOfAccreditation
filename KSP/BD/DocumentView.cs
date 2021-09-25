using System;
using System.Collections.Generic;
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
        [StringLength(10)]
        public string DocumentType_Name { get; set; }

        [Column(TypeName = "date")]
        public DateTime? Date { get; set; }

        [StringLength(400)]
        public string Name { get; set; }

        [StringLength(100)]
        public string Number { get; set; }

        public int? FK_DocumentType { get; set; }

        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int Id { get; set; }
    }
}
