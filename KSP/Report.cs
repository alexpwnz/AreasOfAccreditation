using System.Data.Entity;
using System.Diagnostics;
using System.Threading.Tasks;
using ClosedXML.Report;
using KSP.BD;

namespace KSP
{
    public class Report
    {
        public async Task Form2()
        {
            var temp = new XLTemplate(@"Шаблон Форма2.xlsx");
            KspView[] dates;
            using (var c = new Context())
            {
                dates = await c.KspViews.ToArrayAsync();
            }

            temp.AddVariable("dates", dates);
            temp.Generate();
            temp.SaveAs(@".\out\report2.xlsx");
            Process.Start(new ProcessStartInfo(@".\out\report2.xlsx") {UseShellExecute = true});
        }
    }
}