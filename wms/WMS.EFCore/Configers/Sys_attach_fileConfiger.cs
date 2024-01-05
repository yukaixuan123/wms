using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.Sys;
using WMS.Domain.Entity.Wh;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 公共附件表
    /// </summary>
    internal class Sys_attach_fileConfiger : IEntityTypeConfiguration<Sys_attach_file>
    {
        public void Configure(EntityTypeBuilder<Sys_attach_file> builder)
        {
            builder.ToTable(nameof(Sys_attach_file));
            builder.HasKey(e => e.saf_id);
            builder.Property(e => e.bill_code).HasMaxLength(20).IsUnicode(false).IsRequired();
            builder.Property(e => e.file_id);
           
            builder.Property(e => e.file_type).HasMaxLength(10).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.file_url).HasMaxLength(225).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.create_by).HasMaxLength(64).IsUnicode(false).IsRequired(false);
            builder.Property(e => e.create_time).HasColumnType("datetime").IsRequired();
        }
    }
}
