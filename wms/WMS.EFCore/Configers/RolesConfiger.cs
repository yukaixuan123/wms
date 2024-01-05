using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.User;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 角色
    /// </summary>
    internal class RolesConfiger : IEntityTypeConfiguration<Roles>
    {
        public void Configure(EntityTypeBuilder<Roles> builder)
        {
            builder.ToTable(nameof(Roles));
            builder.HasKey(e => e.RolesID);
            builder.Property(e => e.RolesName).IsRequired().HasMaxLength(20);
            builder.Property(e => e.RolesAuthority).IsRequired(false).HasMaxLength(100);
            builder.Property(e => e.RolesState).IsRequired().HasMaxLength(20);
        }
    }
}
