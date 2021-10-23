using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity;
using System.Linq;

namespace KSP.BD
{
    public partial class Context : DbContext
    {
        public Context()
            : base("name=Context")
        {
        }

        public virtual DbSet<C__RefactorLog> C__RefactorLog { get; set; }
        public virtual DbSet<Document> Documents { get; set; }
        public virtual DbSet<DocumentType> DocumentTypes { get; set; }
        public virtual DbSet<InstallationLocation> InstallationLocations { get; set; }
        public virtual DbSet<KSP> KSPs { get; set; }
        public virtual DbSet<LogEvent> LogEvents { get; set; }
        public virtual DbSet<MeasurementField> MeasurementFields { get; set; }
        public virtual DbSet<MeasuringInstrument> MeasuringInstruments { get; set; }
        public virtual DbSet<MiGroup> MiGroups { get; set; }
        public virtual DbSet<MiGroupDocument> MiGroupDocuments { get; set; }
        public virtual DbSet<Organization> Organizations { get; set; }
        public virtual DbSet<sysdiagram> sysdiagrams { get; set; }
        public virtual DbSet<TitleOwnershipDeed> TitleOwnershipDeeds { get; set; }
        public virtual DbSet<TypeSi> TypeSis { get; set; }
        public virtual DbSet<VerificationTool> VerificationTools { get; set; }
        public virtual DbSet<DocumentView> DocumentViews { get; set; }
        public virtual DbSet<KspView> KspViews { get; set; }
        public virtual DbSet<MiGroupView> MiGroupViews { get; set; }
        public virtual DbSet<UnitView> UnitViews { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Document>()
                .HasMany(e => e.MiGroupDocuments)
                .WithRequired(e => e.Document)
                .HasForeignKey(e => e.FK_Document);

            modelBuilder.Entity<Document>()
                .HasMany(e => e.TitleOwnershipDeeds)
                .WithRequired(e => e.Document)
                .HasForeignKey(e => e.FK_Document)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<DocumentType>()
                .HasMany(e => e.Documents)
                .WithOptional(e => e.DocumentType)
                .HasForeignKey(e => e.FK_DocumentType);

            modelBuilder.Entity<InstallationLocation>()
                .HasMany(e => e.MeasuringInstruments)
                .WithOptional(e => e.InstallationLocation)
                .HasForeignKey(e => e.FK_InstallationLocation);

            modelBuilder.Entity<MeasurementField>()
                .HasMany(e => e.MiGroups)
                .WithRequired(e => e.MeasurementField)
                .HasForeignKey(e => e.FK_MeasurementField)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<MeasuringInstrument>()
                .HasMany(e => e.KSPs)
                .WithRequired(e => e.MeasuringInstrument)
                .HasForeignKey(e => e.FK_MeasuringInstrument);

            modelBuilder.Entity<MeasuringInstrument>()
                .HasMany(e => e.TitleOwnershipDeeds)
                .WithRequired(e => e.MeasuringInstrument)
                .HasForeignKey(e => e.FK_MeasuringInstrument)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<MeasuringInstrument>()
                .HasMany(e => e.VerificationTools)
                .WithRequired(e => e.MeasuringInstrument)
                .HasForeignKey(e => e.FK_MeasuringInstrument);

            modelBuilder.Entity<MiGroup>()
                .HasMany(e => e.KSPs)
                .WithRequired(e => e.MiGroup)
                .HasForeignKey(e => e.FK_MiGroup);

            modelBuilder.Entity<MiGroup>()
                .HasMany(e => e.MiGroupDocuments)
                .WithRequired(e => e.MiGroup)
                .HasForeignKey(e => e.FK_MiGroup);

            modelBuilder.Entity<Organization>()
                .HasMany(e => e.MeasuringInstruments)
                .WithOptional(e => e.Organization)
                .HasForeignKey(e => e.FK_Manufacturer);

            modelBuilder.Entity<Organization>()
                .HasMany(e => e.MeasuringInstruments1)
                .WithOptional(e => e.Organization1)
                .HasForeignKey(e => e.FK_Ownership);

            modelBuilder.Entity<TypeSi>()
                .HasMany(e => e.MeasuringInstruments)
                .WithRequired(e => e.TypeSi)
                .HasForeignKey(e => e.FK_TypeSi)
                .WillCascadeOnDelete(false);

            modelBuilder.Entity<KspView>()
                .Property(e => e.MiGroupDocument)
                .IsUnicode(false);

            modelBuilder.Entity<KspView>()
                .Property(e => e.TitleDocument)
                .IsUnicode(false);
        }
    }
}
